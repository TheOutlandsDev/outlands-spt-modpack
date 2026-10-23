$ErrorActionPreference='Stop'
$root=$PSScriptRoot
$status=Get-Content -LiteralPath (Join-Path $root 'BUILD-STATUS.json') -Raw -Encoding UTF8 | ConvertFrom-Json
Write-Host 'Outlands SPT Author Installer 0.3.0'
Write-Host 'Requires your own working SPT 4.0.13 / EFT 0.16.9.40087 installation.'
Write-Host 'Mods download directly from their authors. No game files are downloaded.'
Write-Host ''
Write-Host 'Some exact author files are currently unavailable. Local imports are supported.'
Write-Host 'An incomplete setup cannot be installed. Read README.md before proceeding.'
$choice=Read-Host 'Choose 1 to JOIN an existing server, or 2 to SELF-HOST'
$mode=if ($choice -eq '1') {'Client'} elseif ($choice -eq '2') {'SelfHost'} else {throw 'Choose 1 or 2.'}
$manual=if ($mode -eq 'Client') {$status.manual_client_files} else {$status.manual_selfhost_files}
Write-Host ('This mode currently needs '+$manual+' files from local imports. Details: MANUAL-FILES.json.')
Write-Host 'D = download/import and check files; I = install; V = verify an existing install; Q = quit'
$action=Read-Host 'Action'
if ($action -eq 'Q') {exit 0}
$target=$null
if ($action -in @('I','V')) {$target=Read-Host 'Full path to your separate compatible SPT installation'}
if ($action -eq 'V') {
    & (Join-Path $root 'Install-Outlands-Authors.ps1') -Action Verify -Mode $mode -SptRoot $target
} elseif ($action -in @('D','I')) {
    $imports=Read-Host 'Folder containing original author ZIP/7z downloads or extracted mod files (Enter to skip)'
    $arguments=@{Action=if($action -eq 'I'){'Install'}else{'Download'};Mode=$mode}
    if ($imports) {$arguments.ImportRoot=@($imports)}
    if ($target) {
        $arguments.SptRoot=$target
        Write-Host 'A complete verified payload is required. Profiles and overwritten files will be backed up.'
        $answer=Read-Host 'Type INSTALL to apply changes; anything else runs a preview'
        $arguments.Apply=($answer -ceq 'INSTALL')
    }
    & (Join-Path $root 'Install-Outlands-Authors.ps1') @arguments
} else {throw 'Choose D, I, V or Q.'}
Write-Host ''
Write-Host 'Reports are stored in your local OutlandsSPT cache. Keep private imports and backup/profile data off GitHub.'
Write-Host 'After installation, follow PLAYING.md to set your private backend/Tailscale connection.'
$null=Read-Host 'Press Enter to close'
