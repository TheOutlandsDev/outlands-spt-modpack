$ErrorActionPreference='Stop'
$root=$PSScriptRoot
$status=Get-Content -LiteralPath (Join-Path $root 'BUILD-STATUS.json') -Raw -Encoding UTF8 | ConvertFrom-Json
Write-Host 'The Outlands SPT Installer 0.4.0'
Write-Host 'Requires your own working SPT 4.0.13 / EFT 0.16.9.40087 installation.'
Write-Host 'Mods download from pinned authors and verified archived originals. No game files are downloaded.'
Write-Host ''
Write-Host 'Four unavailable WTT DLLs are compiled locally from pinned unmodified author source.'
Write-Host 'A portable Microsoft compiler is downloaded to the cache; no global SDK install is made.'
Write-Host 'An incomplete setup cannot be installed. Read README.md before proceeding.'
$choice=Read-Host 'Choose 1 to JOIN an existing server, or 2 to SELF-HOST'
$mode=if ($choice -eq '1') {'Client'} elseif ($choice -eq '2') {'SelfHost'} else {throw 'Choose 1 or 2.'}
$manual=if ($mode -eq 'Client') {$status.manual_client_files} else {$status.manual_selfhost_files}
Write-Host ('Required manual mod imports for this mode: '+$manual+'.')
Write-Host 'D = download and check files; I = install; V = verify; C = private connection setup; Q = quit'
$action=Read-Host 'Action'
if ($action -eq 'Q') {exit 0}
$target=$null
if ($action -in @('D','I','V','C')) {$target=Read-Host 'Full path to your separate compatible SPT installation'}
if ($action -eq 'V') {
    & (Join-Path $root 'Install-Outlands-Authors.ps1') -Action Verify -Mode $mode -SptRoot $target
} elseif ($action -eq 'C') {
    $profile=Read-Host 'Path to the private connection JSON supplied by your server owner'
    $answer=Read-Host 'Type CONNECT to apply the connection with backups; anything else previews'
    & (Join-Path $root 'Set-Outlands-Connection.ps1') -SptRoot $target -Profile $profile -Apply:($answer -ceq 'CONNECT')
} elseif ($action -in @('D','I')) {
    $arguments=@{Action=if($action -eq 'I'){'Install'}else{'Download'};Mode=$mode}
    if ($target) {
        $arguments.SptRoot=$target
        if ($action -eq 'I') {
            Write-Host 'A complete verified payload is required. Profiles and overwritten files will be backed up.'
            $answer=Read-Host 'Type INSTALL to apply changes; anything else runs a preview'
            $arguments.Apply=($answer -ceq 'INSTALL')
        }
    }
    $privateProfile=Join-Path $root 'private-connection.json'
    if ($target -and $mode -eq 'Client' -and (Test-Path -LiteralPath $privateProfile)) { Write-Host 'A private connection profile is present. Applying installation will also configure the launcher backend and webapp shortcut, with backups.' }
    & (Join-Path $root 'Install-Outlands-Authors.ps1') @arguments
    if ($LASTEXITCODE -eq 0 -and $arguments.Apply -and $mode -eq 'Client' -and (Test-Path -LiteralPath $privateProfile)) {
        & (Join-Path $root 'Set-Outlands-Connection.ps1') -SptRoot $target -Profile $privateProfile -Apply
    }
} else {throw 'Choose D, I, V, C or Q.'}
Write-Host ''
Write-Host 'Reports are stored in your local OutlandsSPT cache. Keep private imports and backup/profile data off GitHub.'
Write-Host 'After installation, follow PLAYING.md to set your private backend/Tailscale connection.'
$null=Read-Host 'Press Enter to close'
