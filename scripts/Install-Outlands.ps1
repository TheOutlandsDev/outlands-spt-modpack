[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(Mandatory=$true)][string]$SptRoot,
    [switch]$IncludeThirdParty,
    [switch]$IncludeCoop,
    [switch]$IncludeExperimental,
    [switch]$ReplaceConfigs,
    [switch]$Preview
)
$ErrorActionPreference = 'Stop'
$packageRoot = Split-Path -Parent $PSScriptRoot
& (Join-Path $PSScriptRoot 'Verify-Package.ps1') -PackageRoot $packageRoot
$SptRoot = [IO.Path]::GetFullPath($SptRoot).TrimEnd('\')
$server = Join-Path $SptRoot 'SPT/SPT.Server.exe'
if (-not (Test-Path -LiteralPath $server -PathType Leaf)) { throw 'SptRoot must be an existing installation containing SPT/SPT.Server.exe.' }
if ((Get-Item -LiteralPath $server).VersionInfo.FileVersion -ne '4.0.13') { throw 'This package requires SPT 4.0.13.' }
$core = Get-Content -LiteralPath (Join-Path $SptRoot 'SPT/SPT_Data/configs/core.json') -Raw | ConvertFrom-Json
if ($core.compatibleTarkovVersion -ne '0.16.9.40087') { throw 'The SPT installation must target EFT 0.16.9.40087.' }
if (Get-Process -Name EscapeFromTarkov,SPT.Server,SPT.Launcher,FikaHeadlessManager -ErrorAction SilentlyContinue) { throw 'Close Tarkov, SPT server/launcher, and headless processes before installing.' }
function Assert-InsideRoot([string]$Path) {
    $full = [IO.Path]::GetFullPath($Path)
    if (-not $full.StartsWith($SptRoot + '\', [StringComparison]::OrdinalIgnoreCase)) { throw 'Target path escapes SptRoot.' }
    $probe = $full
    while ($probe -and $probe.Length -ge $SptRoot.Length) {
        if (Test-Path -LiteralPath $probe) {
            if ((Get-Item -LiteralPath $probe -Force).Attributes -band [IO.FileAttributes]::ReparsePoint) { throw "Install target contains a link/reparse point: $probe" }
        }
        $probe = Split-Path -Parent $probe
    }
    return $full
}
$layers = @('baseline')
if ($IncludeThirdParty) { $layers += 'third-party' }
if ($IncludeCoop) { $layers += 'coop' }
if ($IncludeExperimental) { $layers += 'experimental' }
$plan = @()
foreach ($layer in $layers) {
    $layerRoot = Join-Path $packageRoot "payload/$layer"
    if (-not (Test-Path -LiteralPath $layerRoot)) { continue }
    foreach ($file in Get-ChildItem -LiteralPath $layerRoot -Recurse -File) {
        $relative = [IO.Path]::GetRelativePath($layerRoot, $file.FullName)
        $target = Assert-InsideRoot (Join-Path $SptRoot $relative)
        $preserve = -not $ReplaceConfigs -and (Test-Path -LiteralPath $target) -and ($file.Extension -in '.json','.jsonc','.cfg')
        $plan += [pscustomobject]@{ layer=$layer; source=$file.FullName; relative=$relative; target=$target; preserve=$preserve }
    }
}
if ($Preview -or $WhatIfPreference) {
    $plan | Select-Object layer,relative,@{n='action';e={if ($_.preserve) {'preserve existing config'} else {'copy with verified backup'}}} | Format-Table -AutoSize
    Write-Host "Preview only: $($plan.Count) files considered. No writes performed."
    return
}
if (-not $PSCmdlet.ShouldProcess($SptRoot, 'Back up profiles and overwritten files, then install Outlands SPT Modpack')) { return }
$backupRoot = Assert-InsideRoot (Join-Path $SptRoot ('OutlandsBackups/' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N').Substring(0,8)))
New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
$backupRecords = @()
function Backup-File([string]$Path) {
    $relative = [IO.Path]::GetRelativePath($SptRoot, $Path)
    $backup = Join-Path $backupRoot $relative
    New-Item -ItemType Directory -Path (Split-Path -Parent $backup) -Force | Out-Null
    Copy-Item -LiteralPath $Path -Destination $backup
    $before = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
    if ((Get-FileHash -LiteralPath $backup -Algorithm SHA256).Hash -ne $before) { throw "Backup verification failed: $relative" }
    return [pscustomobject]@{ path=$relative; sha256=$before.ToLowerInvariant() }
}
foreach ($profileDirectory in @('SPT/user/profiles','SPT/user/profileData')) {
    $path = Join-Path $SptRoot $profileDirectory
    if (Test-Path -LiteralPath $path) {
        $null = Assert-InsideRoot $path
        foreach ($file in Get-ChildItem -LiteralPath $path -Recurse -File) { $null = Assert-InsideRoot $file.FullName; $backupRecords += Backup-File $file.FullName }
    }
}
foreach ($item in $plan | Where-Object { -not $_.preserve -and (Test-Path -LiteralPath $_.target) }) { $backupRecords += Backup-File $item.target }
$backupRecords | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $backupRoot 'backup-manifest.json') -Encoding utf8
$receipt = @()
foreach ($item in $plan | Where-Object { -not $_.preserve }) {
    New-Item -ItemType Directory -Path (Split-Path -Parent $item.target) -Force | Out-Null
    Copy-Item -LiteralPath $item.source -Destination $item.target -Force
    $hash = (Get-FileHash -LiteralPath $item.source -Algorithm SHA256).Hash
    if ((Get-FileHash -LiteralPath $item.target -Algorithm SHA256).Hash -ne $hash) { throw "Installed file verification failed: $($item.relative). Backups: $backupRoot" }
    $receipt += [pscustomobject]@{ layer=$item.layer; path=$item.relative; sha256=$hash.ToLowerInvariant() }
}
$receipt | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $backupRoot 'installed-files.json') -Encoding utf8
Write-Host "Installed and verified $($receipt.Count) files. Backups: $backupRoot"
Write-Host 'Use a disposable test profile. Fika generates a new API key on first start. This installer does not start the game or server.'
