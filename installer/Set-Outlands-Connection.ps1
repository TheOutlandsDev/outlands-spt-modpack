[CmdletBinding()]
param([Parameter(Mandatory=$true)][string]$SptRoot,[Parameter(Mandatory=$true)][string]$Profile,[switch]$Apply)
$ErrorActionPreference='Stop'
function Safe-Path([string]$Root,[string]$Relative) {
    $base=[IO.Path]::GetFullPath($Root).TrimEnd('\','/')
    if ([IO.Path]::IsPathRooted($Relative) -or $Relative -match '(^|[\\/])\.\.([\\/]|$)|[:\r\n]') { throw 'Unsafe relative path.' }
    $full=[IO.Path]::GetFullPath((Join-Path $base $Relative))
    if (-not $full.StartsWith($base+[IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase)) { throw 'Path escapes installation.' }
    $ancestor=$full
    while ($ancestor) {
        try { if (([IO.File]::GetAttributes($ancestor) -band [IO.FileAttributes]::ReparsePoint) -ne 0) { throw 'Linked paths are not supported.' } }
        catch [IO.FileNotFoundException] {} catch [IO.DirectoryNotFoundException] {}
        $ancestor=[IO.Path]::GetDirectoryName($ancestor)
    }
    return $full
}
function Sha([string]$Path) {
    $stream=[IO.File]::OpenRead($Path);$hash=[Security.Cryptography.SHA256]::Create()
    try { return [BitConverter]::ToString($hash.ComputeHash($stream)).Replace('-','').ToLowerInvariant() }
    finally { $stream.Dispose();$hash.Dispose() }
}
function Private-Url([string]$Value) {
    $uri=$null
    if (-not [uri]::TryCreate($Value,[UriKind]::Absolute,[ref]$uri) -or $uri.Scheme -ne 'https' -or $uri.UserInfo -or $uri.Query -or $uri.Fragment -or $Value -match '[\r\n]') { throw 'Connection profiles require HTTPS URLs without credentials, queries or fragments.' }
    return $uri.AbsoluteUri
}
$network=Get-Content -LiteralPath $Profile -Raw -Encoding UTF8 | ConvertFrom-Json
if ($network.schema -ne 1) { throw 'Unsupported private connection profile.' }
$backend=Private-Url ([string]$network.backend_url)
$webapp=if ($network.webapp_url) { Private-Url ([string]$network.webapp_url) } else { $null }
$configFile=Safe-Path $SptRoot 'SPT/user/launcher/config.json'
if (-not [IO.File]::Exists($configFile)) {
    Write-Host 'Start the compatible SPT launcher once to create its settings, then close it and run connection setup again.'
    exit 2
}
$eft=Safe-Path $SptRoot 'EscapeFromTarkov.exe';$server=Safe-Path $SptRoot 'SPT/SPT.Server.exe'
if (-not [IO.File]::Exists($eft) -or -not [IO.File]::Exists($server) -or (Get-Item -LiteralPath $eft).VersionInfo.FileVersion -ne '0.16.9.40087' -or (Get-Item -LiteralPath $server).VersionInfo.FileVersion -ne '4.0.13') { throw 'Choose a compatible SPT 4.0.13 / EFT 0.16.9.40087 installation.' }
if ((New-Object IO.FileInfo($configFile)).Length -gt 1MB) { throw 'Unexpected launcher settings file.' }
$settings=Get-Content -LiteralPath $configFile -Raw -Encoding UTF8 | ConvertFrom-Json
if (-not $settings.Server -or $settings.Server.Url -isnot [string]) { throw 'Unrecognized launcher settings schema.' }
if (-not $Apply) {
    [ordered]@{preview=$true;name='The Outlands SPT';backend_url=$backend;webapp_url=$webapp;automatic_login_will_be_disabled=$true;credentials_preserved=$true;installation_changed=$false} | ConvertTo-Json
    exit 0
}
if (Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -match 'SPT.Launcher' }) { throw 'Close the SPT launcher before changing its connection settings.' }
$backup=Safe-Path $SptRoot ('Outlands-backups/network-'+(Get-Date -Format 'yyyyMMdd-HHmmss-fff'))
if (Test-Path -LiteralPath $backup) { throw 'Backup directory already exists.' }
New-Item -ItemType Directory -Path $backup | Out-Null
$shortcut=Safe-Path $SptRoot 'The Outlands SPT Webapp.url'
$backups=@()
foreach ($path in @($configFile,$shortcut)) {
    if (-not [IO.File]::Exists($path)) { continue }
    $name=if ($path -eq $configFile) { 'launcher-config.json' } else { 'webapp-shortcut.url' }
    $saved=Safe-Path $backup $name;$before=Sha $path
    Copy-Item -LiteralPath $path -Destination $saved
    if ((Sha $saved) -ne $before) { throw 'Connection backup verification failed; no connection settings changed.' }
    $backups+=@{file=$name;sha256=$before}
}
$settings.Server.Url=$backend
if ($settings.Server.PSObject.Properties['Name']) { $settings.Server.Name='The Outlands SPT' }
if ($settings.PSObject.Properties['UseAutoLogin']) { $settings.UseAutoLogin=$false }
else { $settings | Add-Member -MemberType NoteProperty -Name UseAutoLogin -Value $false }
$utf8=New-Object Text.UTF8Encoding($false)
[IO.File]::WriteAllText($configFile,($settings | ConvertTo-Json -Depth 100),$utf8)
$check=Get-Content -LiteralPath $configFile -Raw -Encoding UTF8 | ConvertFrom-Json
if ($check.Server.Url -ne $backend -or $check.UseAutoLogin) { throw 'Connection settings verification failed. Restore the verified backup.' }
if ($webapp) { [IO.File]::WriteAllText($shortcut,"[InternetShortcut]`r`nURL="+$webapp+"`r`n",$utf8) }
[IO.File]::WriteAllText((Safe-Path $backup 'backup-manifest.json'),($backups | ConvertTo-Json -Depth 5),$utf8)
Write-Host 'The Outlands SPT private connection configured. Existing launcher credentials are preserved; automatic login is disabled for the new backend.'
Write-Host 'No VPN, firewall, certificate trust, server files or player profiles were changed. Use your own server account when you open the launcher.'
exit 0
