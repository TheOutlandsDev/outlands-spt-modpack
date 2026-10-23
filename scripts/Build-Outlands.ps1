param(
    [Parameter(Mandatory=$true)][string]$SptRoot,
    [string]$Project,
    [string]$BuildRoot
)
$ErrorActionPreference = 'Stop'
$packageRoot = Split-Path -Parent $PSScriptRoot
$SptRoot = [IO.Path]::GetFullPath($SptRoot)
if (-not (Test-Path -LiteralPath (Join-Path $SptRoot 'SPT/SPT.Server.exe'))) { throw 'SptRoot must contain SPT/SPT.Server.exe.' }
$serverVersion = (Get-Item -LiteralPath (Join-Path $SptRoot 'SPT/SPT.Server.exe')).VersionInfo.FileVersion
if ($serverVersion -ne '4.0.13') { throw "Expected SPT 4.0.13; detected $serverVersion." }
if (-not $BuildRoot) { $BuildRoot = Join-Path $packageRoot '.build' }
$BuildRoot = [IO.Path]::GetFullPath($BuildRoot)
if ($BuildRoot.StartsWith($SptRoot.TrimEnd('\') + '\', [StringComparison]::OrdinalIgnoreCase)) { throw 'BuildRoot must be outside the game installation.' }
$projects = @(Get-Content -LiteralPath (Join-Path $packageRoot 'manifests/owned-projects.json') -Raw | ConvertFrom-Json)
if ($Project) {
    $projects = @($projects | Where-Object name -eq $Project)
    if ($projects.Count -ne 1) { throw "Unknown project: $Project" }
}
$results = @()
foreach ($entry in $projects) {
    $projectFile = Join-Path $packageRoot $entry.project
    $intermediate = Join-Path $BuildRoot ('obj/' + $entry.name + '/')
    $binaryRoot = Join-Path $BuildRoot ('bin/' + $entry.name + '/')
    Write-Host "Building $($entry.name) for SPT 4.0.13"
    & dotnet build $projectFile -c Release "-p:SptRoot=$SptRoot" "-p:BaseIntermediateOutputPath=$intermediate" "-p:BaseOutputPath=$binaryRoot" '-p:DebugType=None' '-p:DebugSymbols=false' '-p:Deterministic=true' "-p:PathMap=$packageRoot=/_/outlands" --nologo
    if ($LASTEXITCODE -ne 0) { throw "Build failed: $($entry.name)" }
    $built = @(Get-ChildItem -LiteralPath $binaryRoot -Recurse -File -Filter $entry.assembly | Where-Object { $_.FullName -notmatch '\\ref\\' })
    if ($built.Count -ne 1) { throw "Expected one output assembly for $($entry.name); found $($built.Count)." }
    $targetDirectory = Join-Path $packageRoot ("payload/$($entry.layer)/" + $entry.install_directory)
    New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null
    $target = Join-Path $targetDirectory $entry.assembly
    Copy-Item -LiteralPath $built[0].FullName -Destination $target -Force
    $results += [pscustomobject]@{ project = $entry.name; success = $true; assembly = $entry.assembly; sha256 = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash.ToLowerInvariant() }
}
New-Item -ItemType Directory -Path $BuildRoot -Force | Out-Null
$results | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $BuildRoot 'build-results.json') -Encoding utf8
Write-Host "Built $($results.Count) project(s). No files were installed into the game. Package checksums must be regenerated after rebuilding."
