param(
    [string] $MainSptRoot = "C:\SPT",
    [string] $HeadlessRoot = "C:\SPT_HEADLESS",
    [string] $ProfileId = "",
    [string] $RadminIp = "127.0.0.1",
    [string] $BackendUrl = "https://127.0.0.1:6969",
    [string] $BindIp = "Disabled",
    [ValidateSet("Symlink", "HardCopy")]
    [string] $Method = "Symlink"
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($BackendUrl)) {
    throw "BackendUrl cannot be empty."
}

$BackendUrl = $BackendUrl.TrimEnd("/")

function Get-HeadlessProfileId {
    param(
        [string] $Root,
        [string] $RequestedProfileId
    )

    if (-not [string]::IsNullOrWhiteSpace($RequestedProfileId)) {
        return $RequestedProfileId
    }

    $scriptsRoot = Join-Path $Root "SPT\user\mods\fika-server\assets\scripts"
    if (Test-Path -LiteralPath $scriptsRoot) {
        $scriptConfigs = Get-ChildItem -LiteralPath $scriptsRoot -Recurse -File -Filter "HeadlessConfig.json" -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending

        foreach ($configFile in $scriptConfigs) {
            try {
                $config = Get-Content -LiteralPath $configFile.FullName -Raw | ConvertFrom-Json
                if (-not [string]::IsNullOrWhiteSpace([string]$config.ProfileId)) {
                    return [string]$config.ProfileId
                }
            }
            catch {
                Write-Warning "Could not read $($configFile.FullName): $($_.Exception.Message)"
            }
        }
    }

    $profilesRoot = Join-Path $Root "SPT\user\profiles"
    if (Test-Path -LiteralPath $profilesRoot) {
        $profileFiles = Get-ChildItem -LiteralPath $profilesRoot -File -Filter "*.json" -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending

        foreach ($profileFile in $profileFiles) {
            try {
                $profile = Get-Content -LiteralPath $profileFile.FullName -Raw | ConvertFrom-Json
                $username = [string]$profile.info.username
                $nickname = [string]$profile.characters.pmc.Info.Nickname
                if ($username.StartsWith("headless_", [System.StringComparison]::OrdinalIgnoreCase) -or
                    $nickname.StartsWith("headless_", [System.StringComparison]::OrdinalIgnoreCase)) {
                    $id = [string]$profile.info.id
                    if ([string]::IsNullOrWhiteSpace($id)) {
                        $id = [System.IO.Path]::GetFileNameWithoutExtension($profileFile.Name)
                    }

                    return $id
                }
            }
            catch {
                Write-Warning "Could not inspect profile $($profileFile.FullName): $($_.Exception.Message)"
            }
        }
    }

    return ""
}

$installer = Join-Path $MainSptRoot "Fika-Installer.exe"
if (-not (Test-Path -LiteralPath $installer)) {
    throw "Fika-Installer.exe was not found at $installer"
}

$resolvedProfileId = Get-HeadlessProfileId -Root $MainSptRoot -RequestedProfileId $ProfileId
if ([string]::IsNullOrWhiteSpace($resolvedProfileId)) {
    Write-Host "No existing headless profile id detected. The installer will create one."
}
else {
    Write-Host "Using headless profile id: $resolvedProfileId"
}

New-Item -ItemType Directory -Force -Path $HeadlessRoot | Out-Null
Copy-Item -Force -LiteralPath $installer -Destination (Join-Path $HeadlessRoot "Fika-Installer.exe")

Push-Location $HeadlessRoot
try {
    $installArgs = @("install", "headless", "--path", $MainSptRoot, "--method", $Method)
    if (-not [string]::IsNullOrWhiteSpace($resolvedProfileId)) {
        $installArgs += @("--profileId", $resolvedProfileId)
    }

    & (Join-Path $HeadlessRoot "Fika-Installer.exe") @installArgs
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}
finally {
    Pop-Location
}

$resolvedProfileId = Get-HeadlessProfileId -Root $MainSptRoot -RequestedProfileId $resolvedProfileId
if ([string]::IsNullOrWhiteSpace($resolvedProfileId)) {
    throw "Could not resolve a Fika headless profile id after install."
}

$headlessLaunchConfig = Join-Path $HeadlessRoot "HeadlessConfig.json"
[pscustomobject]@{
    ProfileId = $resolvedProfileId
    BackendUrl = $BackendUrl
    StartMinimized = $false
} | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $headlessLaunchConfig

$serverScriptConfig = Join-Path $MainSptRoot "SPT\user\mods\fika-server\assets\scripts\$resolvedProfileId\HeadlessConfig.json"
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $serverScriptConfig) | Out-Null
Copy-Item -Force -LiteralPath $headlessLaunchConfig -Destination $serverScriptConfig

$headlessConfig = Join-Path $HeadlessRoot "BepInEx\config\com.fika.core.cfg"
if (-not (Test-Path -LiteralPath $headlessConfig)) {
    throw "Headless Fika config was not found at $headlessConfig"
}

$backupDir = Join-Path $HeadlessRoot "_codex_backups\fika-headless-config-serverpc"
New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
Copy-Item -Force -LiteralPath $headlessConfig -Destination (Join-Path $backupDir "com.fika.core.cfg")

$text = Get-Content -LiteralPath $headlessConfig -Raw
$text = $text -replace '(?m)^Force IP = .*$', "Force IP = $RadminIp"
$text = $text -replace '(?m)^Force Bind IP = .*$', "Force Bind IP = $BindIp"
$text = $text -replace '(?m)^UDP Port = .*$', "UDP Port = 25565"
Set-Content -LiteralPath $headlessConfig -Value $text -NoNewline

$pluginRoot = Join-Path $HeadlessRoot "BepInEx\plugins"
$disabledRoot = Join-Path $HeadlessRoot "_codex_disabled\headless-client-ui-visual-serverpc\BepInEx\plugins"
New-Item -ItemType Directory -Force -Path $disabledRoot | Out-Null

$items = @(
    "acidphantasm-simpleworkoutqte",
    "acidphantasm-stattrack",
    "BetterBackpacks.dll",
    "BetterThermalNightVision",
    "CodexDiagnostics",
    "FPVDroneModClient",
    "HollywoodFX",
    "HollywoodGraphics",
    "Kat.FastSellInFlea.dll",
    "MergeConsumables",
    "OrionsMods",
    "ozen-Foldables",
    "RaiRai.ColorConverterAPI.dll",
    "redlaser42-HideBetaRework.dll",
    "ReduceFakeInteriorShadow.dll",
    "RZEssentialsClient.dll",
    "SmajlecStamina.dll",
    "SPTBattleAmbience",
    "Terkoiz.FlareEventNotifier.dll",
    "Tyfon.HideoutInProgress.dll",
    "Tyfon.UIFixes.dll",
    "Tyfon.UIFixes.Net.dll",
    "UseItemsFromAnywhere.dll"
)

$moved = @()
foreach ($item in $items) {
    $source = Join-Path $pluginRoot $item
    if (-not (Test-Path -LiteralPath $source)) {
        continue
    }

    Move-Item -Force -LiteralPath $source -Destination (Join-Path $disabledRoot $item)
    $moved += $item
}

[pscustomobject]@{
    disabledAt = (Get-Date).ToString("O")
    reason = "Headless client stability: moved clear visual/UI/menu/diagnostic plugins out of BepInEx load path."
    moved = $moved
} | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $disabledRoot "disabled-manifest.json")

Write-Host "Fika headless client installed/configured at $HeadlessRoot"
Write-Host "ProfileId: $resolvedProfileId"
Write-Host "Backend URL: $BackendUrl"
Write-Host "Radmin/Fika host IP: $RadminIp"
Write-Host "Fika bind IP: $BindIp"
Write-Host "Launch: $HeadlessRoot\FikaHeadlessManager.exe"
