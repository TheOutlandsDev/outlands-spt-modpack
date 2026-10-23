[CmdletBinding()]
param(
    [ValidateSet('Plan','Download','Assemble','Install','Verify')][string]$Action = 'Plan',
    [ValidateSet('Client','SelfHost')][string]$Mode = 'Client',
    [string]$SptRoot,
    [string]$CacheRoot = (Join-Path $env:LOCALAPPDATA 'OutlandsSPT\0.3.0'),
    [string[]]$ImportRoot = @(),
    [string[]]$SourceId = @(),
    [switch]$NoDownload,
    [switch]$Apply
)
$ErrorActionPreference = 'Stop'
$package = [IO.Path]::GetFullPath($PSScriptRoot)
$plan = Get-Content -LiteralPath (Join-Path $package 'download-plan.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$rows = @($plan.files | Where-Object { $Mode -eq 'SelfHost' -or $_.mode -eq 'client' })
$needed = @{}; foreach ($row in $rows) { if ($row.provider.kind -eq 'author') { $needed[$row.provider.source] = $true } }
$sources = @($plan.sources | Where-Object { $needed.ContainsKey($_.id) -and (-not $SourceId.Count -or $_.id -in $SourceId) })
Add-Type -AssemblyName System.IO.Compression.FileSystem

function Safe-Path([string]$Root, [string]$Relative) {
    $base = [IO.Path]::GetFullPath($Root).TrimEnd('\','/')
    if ([IO.Path]::IsPathRooted($Relative) -or $Relative -match '(^|[\\/])\.\.([\\/]|$)' -or $Relative -match '[:\r\n]') { throw 'Unsafe manifest path.' }
    $full = [IO.Path]::GetFullPath((Join-Path $base $Relative))
    if (-not $full.StartsWith($base + [IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase)) { throw 'Path escapes root.' }
    $ancestor = $full
    while ($ancestor) {
        try {
            if (([IO.File]::GetAttributes($ancestor) -band [IO.FileAttributes]::ReparsePoint) -ne 0) { throw 'Reparse points are not supported.' }
        } catch [IO.FileNotFoundException] {} catch [IO.DirectoryNotFoundException] {}
        $parent = [IO.Path]::GetDirectoryName($ancestor)
        if ($parent -eq $ancestor) { break }
        $ancestor = $parent
    }
    return $full
}
function File-Sha([string]$File) {
    $stream = [IO.File]::OpenRead($File); $hash = [Security.Cryptography.SHA256]::Create()
    try { return [BitConverter]::ToString($hash.ComputeHash($stream)).Replace('-','').ToLowerInvariant() }
    finally { $hash.Dispose(); $stream.Dispose() }
}
function Matches([string]$File,$Row) {
    return [IO.File]::Exists($File) -and ((New-Object IO.FileInfo($File)).Length -eq [long]$Row.size) -and ((File-Sha $File) -eq $Row.sha256)
}
foreach ($row in $rows) { $null = Safe-Path $package $row.path }
foreach ($source in $sources) {
    if ($source.id -notmatch '^[a-zA-Z0-9._-]+$' -or $source.sha256 -notmatch '^[a-f0-9]{64}$') { throw 'Invalid source pin.' }
    if (([uri]$source.url).Scheme -ne 'https') { throw 'Only HTTPS author downloads are accepted.' }
}
if ($Action -eq 'Install') {
    if (-not $SptRoot) { throw 'Install requires -SptRoot.' }
    $eft=Safe-Path $SptRoot 'EscapeFromTarkov.exe';$spt=Safe-Path $SptRoot 'SPT/SPT.Server.exe'
    if (-not (Test-Path -LiteralPath $eft) -or -not (Test-Path -LiteralPath $spt)) { throw 'Choose an existing compatible SPT installation.' }
    if ((Get-Item -LiteralPath $eft).VersionInfo.FileVersion -ne '0.16.9.40087' -or (Get-Item -LiteralPath $spt).VersionInfo.FileVersion -ne '4.0.13') { throw 'Requires SPT 4.0.13 / EFT 0.16.9.40087.' }
}
$manual = @($rows | Where-Object { $_.provider.kind -eq 'manual' })
if ($Action -eq 'Plan') {
    [ordered]@{mode=$Mode;required_files=$rows.Count;pinned_author_downloads=$sources.Count;download_bytes=($sources | Measure-Object bytes -Sum).Sum;manual_files=$manual.Count;manual_components=@($manual.component | Sort-Object -Unique);automatic_full_setup=($manual.Count -eq 0);note='Author binaries/assets are downloaded directly, never hosted in this installer. No game/SPT files or private account/network values are supplied. Missing or mismatched files block installation.'} | ConvertTo-Json -Depth 6
    exit 0
}
if ($Action -eq 'Verify') {
    if (-not $SptRoot) { throw 'Verify requires -SptRoot.' }
    & (Join-Path $package 'Outlands-Setup.ps1') -Action Audit -Mode $Mode -SptRoot $SptRoot
    exit $LASTEXITCODE
}
$cache = [IO.Path]::GetFullPath($CacheRoot)
$archives = Safe-Path $cache 'archives'; $stage = Safe-Path $cache ('stage-' + $Mode)
if ($SptRoot) {
    $targetRoot = [IO.Path]::GetFullPath($SptRoot).TrimEnd('\','/')
    if ($cache.StartsWith($targetRoot + '\',[StringComparison]::OrdinalIgnoreCase) -or $targetRoot.StartsWith($cache + '\',[StringComparison]::OrdinalIgnoreCase) -or $cache -eq $targetRoot) { throw 'Keep the download/staging cache separate from the game installation.' }
}
New-Item -ItemType Directory -Force -Path $archives | Out-Null
New-Item -ItemType Directory -Force -Path $stage | Out-Null
$problems = @()

function Download-Source($Source) {
    $file = Safe-Path $archives ($Source.id + '.download')
    if ((Test-Path -LiteralPath $file) -and ((File-Sha $file) -eq $Source.sha256)) { return $file }
    $part = Safe-Path $archives ($Source.id + '.part')
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    for ($attempt=0; $attempt -lt 2; $attempt++) {
        $url = [uri]$Source.url; $response = $null
        try {
            for ($redirect=0; $redirect -lt 10; $redirect++) {
                if ($url.Scheme -ne 'https') { throw 'An author download redirected to insecure HTTP.' }
                $request = [Net.HttpWebRequest]::Create($url)
                $request.UserAgent = 'Outlands-SPT-Author-Installer/0.3.0'
                $request.AllowAutoRedirect = $false
                $request.Timeout = 60000; $request.ReadWriteTimeout = 60000
                $response = $request.GetResponse()
                if ([int]$response.StatusCode -ge 300 -and [int]$response.StatusCode -lt 400) {
                    $next = New-Object uri($url,$response.Headers['Location']); $response.Close(); $response=$null; $url=$next; continue
                }
                break
            }
            if (-not $response -or [int]$response.StatusCode -ne 200) { throw 'Author download did not return a file.' }
            $inputStream=$response.GetResponseStream(); $outputStream=[IO.File]::Create($part)
            try {
                $buffer=New-Object byte[] (1024*1024); $total=0L
                while (($count=$inputStream.Read($buffer,0,$buffer.Length)) -gt 0) {
                    $total+=$count
                    if ($total -gt [long]$Source.bytes) { throw 'Author archive size changed; download rejected.' }
                    $outputStream.Write($buffer,0,$count)
                    Write-Progress -Activity ('Downloading '+$Source.id) -Status 'Direct author source' -PercentComplete ([Math]::Min(100,[int](100*$total/[Math]::Max(1,[long]$Source.bytes))))
                }
            } finally { $outputStream.Dispose(); $inputStream.Dispose(); $response.Close(); $response=$null }
            if ($total -ne [long]$Source.bytes -or (File-Sha $part) -ne $Source.sha256) { throw 'Author archive checksum changed; download rejected.' }
            Move-Item -LiteralPath $part -Destination $file -Force
            Write-Progress -Activity ('Downloading '+$Source.id) -Completed
            return $file
        } catch [Net.WebException] {
            $webResponse=$_.Exception.Response
            if ($webResponse -and [int]$webResponse.StatusCode -eq 429 -and $attempt -eq 0) {
                $delay=60; $seconds=0
                if ([int]::TryParse($webResponse.Headers['Retry-After'],[ref]$seconds)) { $delay=[Math]::Max(60,$seconds) }
                $webResponse.Close()
                Write-Host ('Author host rate limited downloads. Waiting '+$delay+' seconds; no bypass or parallel retry.')
                Start-Sleep -Seconds $delay
                continue
            }
            throw
        } finally { if ($response) { $response.Close() } }
    }
    throw 'Author download is unavailable.'
}

# Index only supplied local files; nothing is executed. A donor directory may contain extracted originals.
$local = @{}; $importFiles=@()
foreach ($root in $ImportRoot) {
    if (-not (Test-Path -LiteralPath $root -PathType Container)) { throw 'An import directory does not exist.' }
    $base = [IO.Path]::GetFullPath($root).TrimEnd('\','/')
    foreach ($f in Get-ChildItem -LiteralPath $base -Recurse -File) {
        $checked = Safe-Path $base $f.FullName.Substring($base.Length+1)
        $importFiles += $checked
        $key=$f.Name.ToLowerInvariant()+':'+$f.Length
        if (-not $local.ContainsKey($key)) { $local[$key]=@() }
        $local[$key]+=$checked
    }
}
$localHash=@{}
function Copy-Owned-File($Provider,$Row,[string]$Destination) {
    $source=Safe-Path $package $Provider.file
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Destination) | Out-Null
    if (Test-Path -LiteralPath $source) {
        if (-not (Matches $source $Row)) { throw 'Bundled owner/settings file failed verification.' }
        Copy-Item -LiteralPath $source -Destination $Destination
    } else {
        $layer=Safe-Path $package 'owner-layer.zip'
        $zip=[IO.Compression.ZipFile]::OpenRead($layer)
        try {
            $entries=@($zip.Entries | Where-Object { $_.FullName -ceq $Provider.file })
            if ($entries.Count -ne 1 -or $entries[0].Length -ne [long]$Row.size) { throw 'Owner layer entry is missing or invalid.' }
            $inputStream=$entries[0].Open();$outputStream=[IO.File]::Create($Destination)
            try {
                $buffer=New-Object byte[] (1024*1024);$expanded=0L
                while (($count=$inputStream.Read($buffer,0,$buffer.Length)) -gt 0) {
                    $expanded+=$count
                    if ($expanded -gt [long]$Row.size) { throw 'Owner entry exceeds its pinned size.' }
                    $outputStream.Write($buffer,0,$count)
                }
            } finally { $outputStream.Dispose();$inputStream.Dispose() }
        } finally { $zip.Dispose() }
        if (-not (Matches $Destination $Row)) { throw 'Owner layer checksum mismatch.' }
    }
}
foreach ($row in $rows) {
    $dest=Safe-Path $stage ('payload/'+$row.path)
    if (Matches $dest $row) { continue }
    $provider=$row.provider
    if ($provider.kind -in @('settings','bundled-owned')) {
        Copy-Owned-File $provider $row $dest
        continue
    }
    $key=[IO.Path]::GetFileName($row.path).ToLowerInvariant()+':'+$row.size
    if ($local.ContainsKey($key)) {
        foreach ($candidate in $local[$key]) {
            if (-not $localHash.ContainsKey($candidate)) { $localHash[$candidate]=File-Sha $candidate }
            if ($localHash[$candidate] -eq $row.sha256) {
                New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dest) | Out-Null
                Copy-Item -LiteralPath $candidate -Destination $dest; break
            }
        }
    }
}

function Stream-Tar-Member([string]$Archive,[string]$Member,[string]$Temp,[long]$MaxBytes) {
    # Native Windows bsdtar streams one selected member; it never extracts archive paths.
    $tar=Join-Path $env:WINDIR 'System32\tar.exe'
    if (-not (Test-Path -LiteralPath $tar)) { throw 'Windows tar.exe is required for this archive compression. Extract the author archive manually and use -ImportRoot.' }
    $start=New-Object Diagnostics.ProcessStartInfo
    $start.FileName=$tar
    $start.Arguments='-xOf "'+$Archive+'" -- "'+$Member+'"'
    $start.UseShellExecute=$false;$start.CreateNoWindow=$true;$start.RedirectStandardOutput=$true;$start.RedirectStandardError=$true
    $process=New-Object Diagnostics.Process;$process.StartInfo=$start;$null=$process.Start()
    $errors=$process.StandardError.ReadToEndAsync();$stream=[IO.File]::Create($Temp)
    try {
        $buffer=New-Object byte[] (1024*1024);$total=0L
        while (($count=$process.StandardOutput.BaseStream.Read($buffer,0,$buffer.Length)) -gt 0) {
            $total+=$count
            if ($total -gt $MaxBytes) { $process.Kill();throw 'Expanded archive member exceeds its pinned size.' }
            $stream.Write($buffer,0,$count)
        }
        $process.WaitForExit()
        if ($process.ExitCode -ne 0) { throw 'Author archive member could not be read; use a manually extracted original.' }
    } finally { $stream.Dispose();$process.Dispose() }
}

function Copy-Member([string]$Archive,$Source,$Row,[string]$ImportMember) {
    $member=if ($ImportMember) { $ImportMember } else { [string]$Row.provider.member }
    $transform=if ($ImportMember) { $null } else { $Row.provider.transform }
    $sourceSize=if ($transform) { [long]$Row.provider.source_size } else { [long]$Row.size }
    if ([IO.Path]::IsPathRooted($member) -or $member -match '(^|[\\/])\.\.([\\/]|$)' -or $member -match '[:\r\n"]' -or $member.StartsWith('-')) { throw 'Unsafe archive member rejected.' }
    $target=Safe-Path $stage ('payload/'+$Row.path)
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $target) | Out-Null
    $temp=Safe-Path $stage ('payload/'+$Row.path+'.part')
    if ($Source.format -eq 'zip') {
        $nativeFallback=$false
        $zip=[IO.Compression.ZipFile]::OpenRead($Archive)
        try {
            # .NET Framework changes DOS-origin ZIP entry separators on Windows.
            $entries=@($zip.Entries | Where-Object { $_.FullName.Replace('\','/') -ceq $member.Replace('\','/') })
            if ($entries.Count -ne 1 -or $entries[0].Length -ne $sourceSize) { throw 'Missing, duplicate or unexpected archive member.' }
            try { $inputStream=$entries[0].Open() } catch [IO.InvalidDataException] { $nativeFallback=$true }
            if (-not $nativeFallback) {
                $outputStream=[IO.File]::Create($temp)
                try {
                    $buffer=New-Object byte[] (1024*1024);$expanded=0L
                    while (($count=$inputStream.Read($buffer,0,$buffer.Length)) -gt 0) {
                        $expanded+=$count
                        if ($expanded -gt $sourceSize) { throw 'Expanded archive member exceeds its pinned size.' }
                        $outputStream.Write($buffer,0,$count)
                    }
                } finally { $outputStream.Dispose();$inputStream.Dispose() }
            }
        } finally { $zip.Dispose() }
        if ($nativeFallback) { Stream-Tar-Member $Archive $member $temp $sourceSize }
    } elseif ($Source.format -eq '7z') {
        Stream-Tar-Member $Archive $member $temp $sourceSize
    } elseif ($Source.format -eq 'raw' -and -not $member) { Copy-Item -LiteralPath $Archive -Destination $temp }
    else { throw 'Unsupported author archive format.' }
    if ($transform) {
        if ($transform.encoding -ne 'utf-8' -or $transform.newline -notin @('lf','crlf') -or (File-Sha $temp) -ne $Row.provider.source_sha256) { throw 'Author text source or permitted normalization does not match.' }
        $utf8=New-Object Text.UTF8Encoding($false,$true)
        $text=[IO.File]::ReadAllText($temp,$utf8).Replace("`r`n","`n")
        if ($transform.newline -eq 'crlf') { $text=$text.Replace("`n","`r`n") }
        [IO.File]::WriteAllText($temp,$text,(New-Object Text.UTF8Encoding([bool]$transform.bom)))
    }
    if (-not (Matches $temp $Row)) { throw 'Extracted author file checksum mismatch.' }
    Move-Item -LiteralPath $temp -Destination $target -Force
}

# Manual author downloads can be supplied as ZIP/7z archives without republishing them.
# Only pinned expected members are copied; the archive's directory layout is never extracted.
$wantedByName=@{}
foreach ($row in $rows) {
    if (Matches (Safe-Path $stage ('payload/'+$row.path)) $row) { continue }
    $key=[IO.Path]::GetFileName($row.path).ToLowerInvariant()
    if (-not $wantedByName.ContainsKey($key)) { $wantedByName[$key]=@() }
    $wantedByName[$key]+=$row
}
foreach ($file in $importFiles) {
    $stream=[IO.File]::OpenRead($file);$header=New-Object byte[] 6
    try { $read=$stream.Read($header,0,6) } finally { $stream.Dispose() }
    $format=$null;$members=@()
    if ($read -ge 4 -and $header[0] -eq 80 -and $header[1] -eq 75 -and $header[2] -eq 3 -and $header[3] -eq 4) {
        $format='zip';$zip=$null
        try { $zip=[IO.Compression.ZipFile]::OpenRead($file);$members=@($zip.Entries | Where-Object { -not $_.FullName.EndsWith('/') } | ForEach-Object { $_.FullName }) }
        catch { $problems+=@{source='local-import';problem='A supplied ZIP was unreadable.'};continue }
        finally { if ($zip) { $zip.Dispose() } }
    } elseif ($read -eq 6 -and [BitConverter]::ToString($header) -eq '37-7A-BC-AF-27-1C') {
        $format='7z';$tar=Join-Path $env:WINDIR 'System32\tar.exe'
        if (-not (Test-Path -LiteralPath $tar)) { continue }
        $members=@(& $tar -tf $file 2>$null)
        if ($LASTEXITCODE -ne 0) { continue }
    }
    if (-not $format) { continue }
    foreach ($member in $members) {
        $key=[IO.Path]::GetFileName([string]$member).ToLowerInvariant()
        if (-not $wantedByName.ContainsKey($key)) { continue }
        foreach ($row in $wantedByName[$key]) {
            if (Matches (Safe-Path $stage ('payload/'+$row.path)) $row) { continue }
            try { Copy-Member $file ([pscustomobject]@{format=$format}) $row ([string]$member) }
            catch { continue } # A different archive/version is not an accepted substitute.
        }
    }
}

$authorRows=@{}
foreach ($row in $rows) {
    if ($row.provider.kind -ne 'author') { continue }
    $id=[string]$row.provider.source
    if (-not $authorRows.ContainsKey($id)) { $authorRows[$id]=New-Object 'Collections.Generic.List[object]' }
    $authorRows[$id].Add($row)
}
foreach ($source in $sources) {
    $sourceRows=@($authorRows[$source.id] | Where-Object { -not (Matches (Safe-Path $stage ('payload/'+$_.path)) $_) })
    if (-not $sourceRows.Count) { continue }
    $archive=Safe-Path $archives ($source.id+'.download')
    try {
        if (-not (Test-Path -LiteralPath $archive)) {
            foreach ($candidate in $importFiles) {
                if ((Get-Item -LiteralPath $candidate).Length -ne [long]$source.bytes) { continue }
                if (-not $localHash.ContainsKey($candidate)) { $localHash[$candidate]=File-Sha $candidate }
                if ($localHash[$candidate] -eq $source.sha256) { Copy-Item -LiteralPath $candidate -Destination $archive;break }
            }
        }
        if (-not (Test-Path -LiteralPath $archive) -or (File-Sha $archive) -ne $source.sha256) {
            if ($NoDownload -or $Action -eq 'Assemble') { throw 'Pinned archive is not in the cache.' }
            $archive=Download-Source $source
            # Be conservative with the author download host's separate throttles.
            if (([uri]$source.url).Host -match '(^|\.)(sp-mod\.com|sp-tarkov\.com)$') { Start-Sleep -Seconds 5 }
            else { Start-Sleep -Milliseconds 200 }
        }
        foreach ($row in $sourceRows) { Copy-Member $archive $source $row }
    } catch { $problems+=@{source=$source.id;problem=$_.Exception.Message};Write-Warning ('Could not complete author source '+$source.id+'. See report.json; no game installation has changed.') }
}

$missing=@()
foreach ($row in $rows) { if (-not (Matches (Safe-Path $stage ('payload/'+$row.path)) $row)) { $missing+=@{path=$row.path;component=$row.component;provider=$row.provider.kind;sha256=$row.sha256;size=$row.size} } }
$report=[ordered]@{version='0.3.0';mode=$Mode;required_files=$rows.Count;verified_files=($rows.Count-$missing.Count);ready=($missing.Count -eq 0);missing=$missing;source_problems=$problems;game_installation_changed=$false}
[IO.File]::WriteAllText((Safe-Path $cache ('report-'+$Mode+'.json')),($report | ConvertTo-Json -Depth 10),(New-Object Text.UTF8Encoding($false)))
Write-Host ('Verified '+($rows.Count-$missing.Count)+' / '+$rows.Count+' files. Missing: '+$missing.Count+'.')
if ($missing.Count) {
    Write-Host 'Incomplete: no installation was performed. Obtain the exact author files listed in the report, extract locally, then rerun with -ImportRoot. Do not substitute latest releases.'
    exit 2
}
foreach ($name in @('setup-lock.json','Outlands-Setup.ps1','README.md','PLAYING.md','mod-downloads.json','build.json')) {
    Copy-Item -LiteralPath (Safe-Path $package $name) -Destination (Safe-Path $stage $name)
}
if ($Action -eq 'Install') {
    if (-not $SptRoot) { throw 'Install requires -SptRoot.' }
    & (Join-Path $stage 'Outlands-Setup.ps1') -Action Install -Mode $Mode -SptRoot $SptRoot -Apply:$Apply
    exit $LASTEXITCODE
}
Write-Host 'Complete staged mod files. Install still requires a compatible legitimate SPT/EFT installation and private network configuration. No gameplay or connectivity test is implied.'
exit 0
