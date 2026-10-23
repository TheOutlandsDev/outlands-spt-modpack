[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]$BuildPlan,
    [Parameter(Mandatory=$true)][object[]]$Rows,
    [Parameter(Mandatory=$true)][string]$ArchivesRoot,
    [Parameter(Mandatory=$true)][string]$StageRoot,
    [Parameter(Mandatory=$true)][string]$CacheRoot,
    [Parameter(Mandatory=$true)][string]$SptRoot,
    [Parameter(Mandatory=$true)][object[]]$Sources
)
$ErrorActionPreference='Stop'
# Called by the downloader after its HTTPS/length/SHA checks. Only our generated
# projects are executed; downloaded author .csproj/.targets/scripts are never used.
function Build-SafePath([string]$Root,[string]$Relative) { return Safe-Path $Root $Relative }
function Checked-Source([string]$Id) {
    $source=@($Sources | Where-Object { $_.id -ceq $Id })
    if ($source.Count -ne 1) { throw 'A source-build input has no unique pinned source.' }
    $file=Build-SafePath $ArchivesRoot ($Id+'.download')
    if (-not [IO.File]::Exists($file) -or (New-Object IO.FileInfo($file)).Length -ne [long]$source[0].bytes -or (File-Sha $file) -ne $source[0].sha256) { throw ('Source-build input is missing or invalid: '+$Id) }
    return $file
}
function Stream-Sha($Stream) {
    $algorithm=[Security.Cryptography.SHA256]::Create()
    try { return [BitConverter]::ToString($algorithm.ComputeHash($Stream)).Replace('-','').ToLowerInvariant() }
    finally { $algorithm.Dispose() }
}
function Expand-CheckedSdk([string]$Archive,[string]$Destination) {
    # Check the complete SDK tree against the verified archive before executing it.
    # This also repairs a modified cached file and rejects unlisted extra files.
    $zip=[IO.Compression.ZipFile]::OpenRead($Archive)
    $expected=@{}
    try {
        foreach ($entry in $zip.Entries) {
            $relative=$entry.FullName.Replace('\','/')
            if (-not $relative -or $relative.EndsWith('/')) { continue }
            if ($expected.ContainsKey($relative)) { throw 'Duplicate SDK archive entry.' }
            $expected[$relative]=$true
            $target=Build-SafePath $Destination $relative
            $inputStream=$entry.Open()
            try { $expectedSha=Stream-Sha $inputStream } finally { $inputStream.Dispose() }
            if ([IO.File]::Exists($target) -and (New-Object IO.FileInfo($target)).Length -eq $entry.Length -and (File-Sha $target) -eq $expectedSha) { continue }
            New-Item -ItemType Directory -Force -Path (Split-Path -Parent $target) | Out-Null
            $inputStream=$entry.Open();$outputStream=[IO.File]::Create($target)
            try { $inputStream.CopyTo($outputStream) } finally { $outputStream.Dispose();$inputStream.Dispose() }
            if ((File-Sha $target) -ne $expectedSha) { throw 'Portable SDK extraction failed verification.' }
        }
    } finally { $zip.Dispose() }
    foreach ($file in Get-ChildItem -LiteralPath $Destination -File -Recurse -Force) {
        $relative=$file.FullName.Substring($Destination.TrimEnd('\','/').Length+1).Replace('\','/')
        $null=Build-SafePath $Destination $relative
        if (-not $expected.ContainsKey($relative)) { throw 'Portable SDK contains an unlisted file. Use a new clean cache folder.' }
    }
}
function Run-Dotnet([string]$Executable,[string]$Arguments,[string]$WorkingDirectory,[string]$LogFile,[hashtable]$Environment) {
    $start=New-Object Diagnostics.ProcessStartInfo
    $start.FileName=$Executable;$start.Arguments=$Arguments;$start.WorkingDirectory=$WorkingDirectory
    $start.UseShellExecute=$false;$start.CreateNoWindow=$true;$start.RedirectStandardOutput=$true;$start.RedirectStandardError=$true
    foreach ($key in @($start.EnvironmentVariables.Keys)) {
        if ($key -match '^(MSBUILD|DOTNET|NUGET|CORECLR|COMPlus|COR_)' -or $key -in @('RoslynTargetsPath','CscToolPath','CscToolExe')) { $start.EnvironmentVariables.Remove($key) }
    }
    foreach ($key in $Environment.Keys) { $start.EnvironmentVariables[$key]=[string]$Environment[$key] }
    $process=New-Object Diagnostics.Process;$process.StartInfo=$start
    try {
        $null=$process.Start();$output=$process.StandardOutput.ReadToEndAsync();$errors=$process.StandardError.ReadToEndAsync()
        if (-not $process.WaitForExit(300000)) { $process.Kill();throw 'Source compilation exceeded five minutes.' }
        [IO.File]::WriteAllText($LogFile,($output.Result+"`r`n"+$errors.Result),(New-Object Text.UTF8Encoding($false)))
        if ($process.ExitCode -ne 0) { throw ('Source compilation failed. See the local build log: '+$LogFile) }
    } finally { $process.Dispose() }
}
if (-not $SptRoot -or $SptRoot -match '[\r\n"]') { throw 'Source compilation needs -SptRoot pointing to your own compatible SPT/EFT installation.' }
$eft=Build-SafePath $SptRoot 'EscapeFromTarkov.exe';$server=Build-SafePath $SptRoot 'SPT/SPT.Server.exe'
if (-not [IO.File]::Exists($eft) -or -not [IO.File]::Exists($server) -or (Get-Item -LiteralPath $eft).VersionInfo.FileVersion -ne '0.16.9.40087' -or (Get-Item -LiteralPath $server).VersionInfo.FileVersion -ne '4.0.13') { throw 'Source compilation requires SPT 4.0.13 / EFT 0.16.9.40087.' }
$projects=@($BuildPlan.projects | Where-Object { $id=$_.id;@($Rows | Where-Object { $_.provider.kind -eq 'source-build' -and $_.provider.project -ceq $id }).Count -gt 0 })
if (-not $projects.Count) { return }
$buildRoot=Build-SafePath $CacheRoot 'source-builds'
New-Item -ItemType Directory -Force -Path $buildRoot | Out-Null
$sdkRoot=Build-SafePath $buildRoot ('sdk-'+$BuildPlan.sdk.version)
New-Item -ItemType Directory -Force -Path $sdkRoot | Out-Null
$sdkArchive=Checked-Source $BuildPlan.sdk.source
Write-Host 'Verifying the pinned portable Microsoft compiler. No global SDK installation is made.'
Expand-CheckedSdk $sdkArchive $sdkRoot
$dotnet=Build-SafePath $sdkRoot 'dotnet.exe'
$runRoot=Build-SafePath $buildRoot ('run-'+[Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force -Path $runRoot | Out-Null
$feed=Build-SafePath $runRoot 'feed';$packages=Build-SafePath $runRoot 'packages';$cliHome=Build-SafePath $runRoot 'cli-home'
New-Item -ItemType Directory -Force -Path $feed,$packages,$cliHome | Out-Null
$projectSourceIds=@{};foreach ($project in $projects) { foreach ($id in $project.sources) { $projectSourceIds[$id]=$true } }
foreach ($id in @($BuildPlan.package_sources | Where-Object { $projectSourceIds.ContainsKey($_) })) {
    $archive=Checked-Source $id
    $source=@($Sources | Where-Object { $_.id -ceq $id })[0]
    if ($source.filename -notmatch '^[a-zA-Z0-9._-]+\.nupkg$') { throw 'Invalid pinned NuGet package filename.' }
    Copy-Item -LiteralPath $archive -Destination (Build-SafePath $feed $source.filename)
}
$nuget=Build-SafePath $runRoot 'NuGet.Config'
$xmlFeed=[Security.SecurityElement]::Escape($feed)
[IO.File]::WriteAllText($nuget,('<configuration><packageSources><clear/><add key="pinned-local" value="'+$xmlFeed+'"/></packageSources><disabledPackageSources><clear/></disabledPackageSources></configuration>'),(New-Object Text.UTF8Encoding($false)))
[IO.File]::WriteAllText((Build-SafePath $runRoot 'global.json'),('{"sdk":{"version":"'+$BuildPlan.sdk.version+'","rollForward":"disable","allowPrerelease":false}}'),(New-Object Text.UTF8Encoding($false)))
$environment=@{DOTNET_ROOT=$sdkRoot;DOTNET_MULTILEVEL_LOOKUP='0';DOTNET_CLI_HOME=$cliHome;DOTNET_CLI_TELEMETRY_OPTOUT='1';DOTNET_SKIP_FIRST_TIME_EXPERIENCE='1';DOTNET_NOLOGO='1';DOTNET_ADD_GLOBAL_TOOLS_TO_PATH='0';DOTNET_CLI_WORKLOAD_UPDATE_NOTIFY_DISABLE='true';DOTNET_GENERATE_ASPNET_CERTIFICATE='false';NUGET_PACKAGES=$packages;NUGET_HTTP_CACHE_PATH=(Build-SafePath $runRoot 'nuget-http');NUGET_SCRATCH=(Build-SafePath $runRoot 'nuget-scratch');MSBuildEnableWorkloadResolver='false'}
$receipt=@()
foreach ($project in $projects) {
    if ($project.id -notmatch '^[a-zA-Z0-9._-]+$') { throw 'Invalid source-build project identifier.' }
    foreach ($reference in $project.reference_files) {
        $root=if ($reference.root -eq 'spt') { $SptRoot } elseif ($reference.root -eq 'stage') { Build-SafePath $StageRoot 'payload' } else { throw 'Invalid build reference root.' }
        $file=Build-SafePath $root $reference.path
        if (-not (Matches $file $reference)) { throw ('Your build reference differs from the pinned compatible installation: '+$reference.path) }
    }
    $projectRoot=Build-SafePath $runRoot $project.id
    New-Item -ItemType Directory -Force -Path $projectRoot | Out-Null
    foreach ($source in $project.source_files) {
        $original=Checked-Source $source.download_id
        $target=Build-SafePath $projectRoot $source.relative_path
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $target) | Out-Null
        if ($source.transform) {
            if ($source.transform.type -ne 'git-windows-crlf' -or $source.relative_path -notmatch '\.cs$') { throw 'Unsupported author source checkout transformation.' }
            $raw=[IO.File]::ReadAllBytes($original)
            $bom=$raw.Length -ge 3 -and $raw[0] -eq 239 -and $raw[1] -eq 187 -and $raw[2] -eq 191
            $utf8=New-Object Text.UTF8Encoding($false,$true)
            $text=$utf8.GetString($raw)
            if ($bom) { $text=$text.Substring(1) }
            $text=$text.Replace("`r`n","`n").Replace("`n","`r`n")
            [IO.File]::WriteAllText($target,$text,(New-Object Text.UTF8Encoding($bom,$true)))
            if (-not (Matches $target $source.transform)) { throw 'Author Windows source checkout did not match its pinned hash.' }
        } else { Copy-Item -LiteralPath $original -Destination $target }
    }
    $replacements=@{'__SPTROOT__'=$SptRoot;'__STAGEROOT__'=(Build-SafePath $StageRoot 'payload');'__BUILDROOT__'=$projectRoot;'__RUNROOT__'=$runRoot;'__PACKAGEROOT__'=$packages}
    $projectXml=[string]$project.project_xml
    foreach ($token in $replacements.Keys) { $projectXml=$projectXml.Replace($token,[Security.SecurityElement]::Escape([string]$replacements[$token])) }
    if ($projectXml -match '__[A-Z]+__') { throw 'Unresolved build project template.' }
    $projectFile=Build-SafePath $projectRoot ($project.id+'.csproj')
    [IO.File]::WriteAllText($projectFile,$projectXml,(New-Object Text.UTF8Encoding($false)))
    Write-Host ('Compiling unmodified pinned author source: '+$project.id)
    $restoreLog=Build-SafePath $runRoot ($project.id+'-restore.log')
    Run-Dotnet $dotnet ('restore "'+$projectFile+'" --configfile "'+$nuget+'" --packages "'+$packages+'" --disable-parallel -noAutoResponse -p:NuGetAudit=false -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false -p:ImportDirectoryPackagesProps=false -v:q') $runRoot $restoreLog $environment
    $buildLog=Build-SafePath $runRoot ($project.id+'-build.log')
    Run-Dotnet $dotnet ('build "'+$projectFile+'" -c Release --no-restore -noAutoResponse -p:ImportDirectoryBuildProps=false -p:ImportDirectoryBuildTargets=false -p:ImportDirectoryPackagesProps=false -v:q') $runRoot $buildLog $environment
    $output=Build-SafePath $projectRoot $project.output_relative
    $row=@($Rows | Where-Object { $_.provider.kind -eq 'source-build' -and $_.provider.project -ceq $project.id })
    if ($row.Count -ne 1 -or -not (Matches $output $row[0])) { throw ('Generated DLL does not match the reproducible build hash: '+$project.id) }
    $destination=Build-SafePath $StageRoot ('payload/'+$row[0].path)
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $destination) | Out-Null
    Copy-Item -LiteralPath $output -Destination $destination
    $receipt+=@{project=$project.id;sha256=(File-Sha $destination);size=(New-Object IO.FileInfo($destination)).Length;snapshot_sha256=$row[0].snapshot_sha256;author_source_changed=$false}
}
[IO.File]::WriteAllText((Build-SafePath $runRoot 'receipt.json'),(@{projects=$receipt;global_sdk_installed=$false;game_installation_changed=$false}|ConvertTo-Json -Depth 8),(New-Object Text.UTF8Encoding($false)))
