[CmdletBinding()]
param(
    [ValidateSet('Audit','Assemble','Install')][string]$Action = 'Audit',
    [ValidateSet('Client','SelfHost')][string]$Mode = 'Client',
    [string]$SptRoot,
    [string[]]$DonorRoot = @(),
    [string]$Destination,
    [string]$JsonReport,
    [switch]$Apply
)
$ErrorActionPreference = 'Stop'
$packRoot = [IO.Path]::GetFullPath($PSScriptRoot)
$lock = Get-Content -LiteralPath (Join-Path $packRoot 'setup-lock.json') -Raw | ConvertFrom-Json
$rows = @($lock.files | Where-Object { $Mode -eq 'SelfHost' -or $_.mode -eq 'client' })

function File-Sha([string]$File) {
    $stream = [IO.File]::OpenRead($File)
    $algorithm = [Security.Cryptography.SHA256]::Create()
    try { return [BitConverter]::ToString($algorithm.ComputeHash($stream)).Replace('-','').ToLowerInvariant() }
    finally { $algorithm.Dispose(); $stream.Dispose() }
}

function Safe-Path([string]$Root, [string]$Relative) {
    $base = [IO.Path]::GetFullPath($Root).TrimEnd('\','/')
    if ([IO.Path]::IsPathRooted($Relative) -or $Relative -match '(^|[\\/])\.\.([\\/]|$)' -or $Relative -match ':') { throw 'Unsafe relative path in manifest.' }
    $full = [IO.Path]::GetFullPath((Join-Path $base $Relative))
    if (-not $full.StartsWith($base + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) { throw 'Path escapes target root.' }
    $ancestor = $full
    while ($ancestor) {
        if (Test-Path -LiteralPath $ancestor) {
            $item = Get-Item -LiteralPath $ancestor -Force
            if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { throw 'Reparse points are not supported.' }
        }
        $parent = Split-Path -Parent $ancestor
        if ($parent -eq $ancestor) { break }
        $ancestor = $parent
    }
    return $full
}
function Matches($File, $Row) {
    if (-not (Test-Path -LiteralPath $File -PathType Leaf)) { return $false }
    if ((Get-Item -LiteralPath $File).Length -ne [long]$Row.size) { return $false }
    return (File-Sha $File) -eq $Row.sha256
}
function Extra-Dlls([string]$Root) {
    $expected = @{}
    foreach ($row in $rows) { $expected[$row.path.Replace('/','\').ToLowerInvariant()] = $true }
    $bases = @('BepInEx/plugins')
    if ($Mode -eq 'SelfHost') { $bases += 'SPT/user/mods' }
    foreach ($base in $bases) {
        $dir = Safe-Path $Root $base
        if (-not (Test-Path -LiteralPath $dir)) { continue }
        foreach ($f in Get-ChildItem -LiteralPath $dir -File -Recurse -Filter '*.dll') {
            $rel = $f.FullName.Substring([IO.Path]::GetFullPath($Root).TrimEnd('\','/').Length + 1)
            if ($rel -like 'BepInEx\plugins\spt\*') { continue }
            if (-not $expected.ContainsKey($rel.ToLowerInvariant())) { $rel.Replace('\','/') }
        }
    }
}
function Emit-Report($Report) {
    $text = $Report | ConvertTo-Json -Depth 8
    if ($JsonReport) {
        $reportPath = [IO.Path]::GetFullPath($JsonReport)
        if ($SptRoot -and $reportPath.StartsWith([IO.Path]::GetFullPath($SptRoot).TrimEnd('\','/') + '\', [StringComparison]::OrdinalIgnoreCase)) { throw 'Write reports outside the game installation.' }
        [IO.File]::WriteAllText($reportPath, $text, (New-Object Text.UTF8Encoding($false)))
    }
    Write-Output $text
}

if ($Action -eq 'Audit') {
    if (-not $SptRoot) { throw 'Audit requires -SptRoot.' }
    $missing = @(); $different = @()
    foreach ($row in $rows) {
        $file = Safe-Path $SptRoot $row.path
        if (-not (Test-Path -LiteralPath $file -PathType Leaf)) { $missing += $row.path }
        elseif (-not (Matches $file $row)) { $different += $row.path }
    }
    $extras = @(Extra-Dlls $SptRoot)
    Emit-Report ([ordered]@{build=$lock.version;mode=$Mode;expected_files=$rows.Count;missing=$missing;different=$different;extra_dlls=$extras;exact_mod_file_match=($missing.Count -eq 0 -and $different.Count -eq 0 -and $extras.Count -eq 0);note='File comparison only. Does not establish loaded plugin selection, base game validity or successful multiplayer. Fresh network/API configuration will intentionally differ.'})
    if ($missing.Count -or $different.Count -or $extras.Count) { exit 2 }
    exit 0
}

if ($Action -eq 'Assemble') {
    if (-not $Destination) { throw 'Assemble requires a NEW -Destination folder.' }
    $destRoot = [IO.Path]::GetFullPath($Destination)
    if (Test-Path -LiteralPath $destRoot) { throw 'Destination already exists. Use a new empty destination.' }
    $sources = @((Join-Path $packRoot 'payload')) + @($DonorRoot)
    # Search only locally supplied files; no automatic execution, download or version substitution.
    $index = @{}
    foreach ($source in $sources) {
        if (-not (Test-Path -LiteralPath $source -PathType Container)) { continue }
        foreach ($f in Get-ChildItem -LiteralPath $source -Recurse -File) {
            $safe = Safe-Path $source ($f.FullName.Substring([IO.Path]::GetFullPath($source).TrimEnd('\','/').Length + 1))
            $key = $f.Name.ToLowerInvariant() + ':' + $f.Length
            if (-not $index.ContainsKey($key)) { $index[$key] = @() }
            $index[$key] += $safe
        }
    }
    $found = @{}; $missing = @(); $hashCache = @{}
    foreach ($row in $rows) {
        $key = [IO.Path]::GetFileName($row.path).ToLowerInvariant() + ':' + $row.size
        $match = $null
        if ($index.ContainsKey($key)) {
            foreach ($candidate in $index[$key]) {
                if (-not $hashCache.ContainsKey($candidate)) { $hashCache[$candidate] = (File-Sha $candidate) }
                if ($hashCache[$candidate] -eq $row.sha256) { $match = $candidate; break }
            }
        }
        if ($match) { $found[$row.path] = $match } else { $missing += $row.path }
    }
    if ($missing.Count) {
        Emit-Report ([ordered]@{build=$lock.version;mode=$Mode;ready=$false;found=$found.Count;missing=$missing;destination_created=$false;note='Obtain exact author versions. Customized or sanitized configuration may require the pack maintainer; latest/default versions are not silently accepted.'})
        exit 2
    }
    foreach ($row in $rows) {
        $target = Safe-Path $destRoot ('payload/' + $row.path)
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $target) | Out-Null
        Copy-Item -LiteralPath $found[$row.path] -Destination $target
        if (-not (Matches $target $row)) { throw 'Copy verification failed.' }
    }
    foreach ($name in @('setup-lock.json','Outlands-Setup.ps1','README.md','PLAYING.md','mod-downloads.json','build.json')) {
        Copy-Item -LiteralPath (Join-Path $packRoot $name) -Destination (Join-Path $destRoot $name)
    }
    Emit-Report ([ordered]@{build=$lock.version;mode=$Mode;ready=$true;files=$rows.Count;note='Assembled exact mod files for local use. This does not grant redistribution permission.'})
    exit 0
}

if (-not $SptRoot) { throw 'Install requires -SptRoot.' }
$server = Safe-Path $SptRoot 'SPT/SPT.Server.exe'
$eft = Safe-Path $SptRoot 'EscapeFromTarkov.exe'
if (-not (Test-Path -LiteralPath $server) -or -not (Test-Path -LiteralPath $eft)) { throw 'Install requires an existing compatible SPT installation.' }
if ((Get-Item -LiteralPath $server).VersionInfo.FileVersion -ne '4.0.13' -or (Get-Item -LiteralPath $eft).VersionInfo.FileVersion -ne '0.16.9.40087') { throw 'Requires SPT 4.0.13 and EFT 0.16.9.40087.' }
if (Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -match 'EscapeFromTarkov|SPT.Server|SPT.Launcher|SPT-Fika' }) { throw 'Close the game, launcher and server first.' }
$missing = @()
foreach ($row in $rows) { if (-not (Matches (Safe-Path (Join-Path $packRoot 'payload') $row.path) $row)) { $missing += $row.path } }
$extras = @(Extra-Dlls $SptRoot)
if ($missing.Count -or $extras.Count) {
    Emit-Report ([ordered]@{ready=$false;missing_or_different_payload=$missing;extra_installed_dlls=$extras;installation_changed=$false})
    exit 2
}
if (-not $Apply) {
    Emit-Report ([ordered]@{ready=$true;preview=$true;mode=$Mode;files=$rows.Count;installation_changed=$false;next_step='Add -Apply to back up profiles and overwritten files, then install. Configure new network values using PLAYING.md.'})
    exit 0
}
$requiredSpace = [long](($rows | Measure-Object -Property size -Sum).Sum * 2)
$driveRoot = [IO.Path]::GetPathRoot([IO.Path]::GetFullPath($SptRoot))
$driveInfo = New-Object IO.DriveInfo($driveRoot)
if ($driveInfo.AvailableFreeSpace -lt $requiredSpace) { throw 'Insufficient free space for verified backups and installation. Use a separate drive with enough free space.' }
$backupRel = 'Outlands-backups/' + (Get-Date -Format 'yyyyMMdd-HHmmss-fff')
$backup = Safe-Path $SptRoot $backupRel
if (Test-Path -LiteralPath $backup) { throw 'Backup directory already exists.' }
$backupRows = @()
# Back up every profile before any mod changes. Do not include these in public uploads.
$profiles = Safe-Path $SptRoot 'SPT/user/profiles'
if (Test-Path -LiteralPath $profiles) {
    foreach ($file in Get-ChildItem -LiteralPath $profiles -File -Recurse) {
        $rel = $file.FullName.Substring([IO.Path]::GetFullPath($SptRoot).TrimEnd('\','/').Length + 1)
        $target = Safe-Path $backup $rel
        $source = Safe-Path $SptRoot $rel
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $target) | Out-Null
        Copy-Item -LiteralPath $source -Destination $target
        $hash = (File-Sha $source)
        if ((File-Sha $target) -ne $hash) { throw 'Profile backup verification failed; no mod files were changed.' }
        $backupRows += @{path=$rel;sha256=$hash}
    }
}
# Back up all overwrite candidates before the first mod write.
foreach ($row in $rows) {
    $target = Safe-Path $SptRoot $row.path
    if (Test-Path -LiteralPath $target) {
        $saved = Safe-Path $backup $row.path
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $saved) | Out-Null
        Copy-Item -LiteralPath $target -Destination $saved
        $hash = (File-Sha $target)
        if ((File-Sha $saved) -ne $hash) { throw 'Overwrite backup verification failed; no mod files were changed.' }
        $backupRows += @{path=$row.path;sha256=$hash}
    }
}
foreach ($row in $rows) {
    $target = Safe-Path $SptRoot $row.path
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $target) | Out-Null
    Copy-Item -LiteralPath (Safe-Path (Join-Path $packRoot 'payload') $row.path) -Destination $target
    if (-not (Matches $target $row)) { throw ('Install copy verification failed. Restore from ' + $backupRel) }
}
New-Item -ItemType Directory -Force -Path $backup | Out-Null
$backupRows | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $backup 'backup-manifest.json') -Encoding UTF8
Emit-Report ([ordered]@{installed=$true;mode=$Mode;files=$rows.Count;backup=$backupRel;next_step='Configure fresh connection/account values using PLAYING.md, then perform a real join/raid test.'})
