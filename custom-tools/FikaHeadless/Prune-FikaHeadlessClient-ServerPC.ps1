param(
    [string] $HeadlessRoot = "C:\SPT_HEADLESS",
    [switch] $Apply
)

$ErrorActionPreference = "Stop"
$Preview = -not $Apply

$pluginRoot = Join-Path $HeadlessRoot "BepInEx\plugins"
if (-not (Test-Path -LiteralPath $pluginRoot)) {
    throw "Headless plugin folder was not found at $pluginRoot"
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$disabledRoot = Join-Path $HeadlessRoot "_codex_disabled\headless-client-nonessential-$stamp\BepInEx\plugins"

$items = @(
    "acidphantasm-simpleworkoutqte",
    "acidphantasm-stattrack",
    "BetterBackpacks.dll",
    "BetterThermalNightVision",
    "CodexDiagnostics",
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
$missing = @()

foreach ($item in $items) {
    $source = Join-Path $pluginRoot $item
    if (-not (Test-Path -LiteralPath $source)) {
        $missing += $item
        continue
    }

    $destination = Join-Path $disabledRoot $item
    if ($Preview) {
        Write-Host "Would move: $source -> $destination"
        continue
    }

    New-Item -ItemType Directory -Force -Path $disabledRoot | Out-Null
    Move-Item -Force -LiteralPath $source -Destination $destination
    $moved += $item
}

if (-not $Preview) {
    New-Item -ItemType Directory -Force -Path $disabledRoot | Out-Null
    [pscustomobject]@{
        disabledAt = (Get-Date).ToString("O")
        reason = "Fika headless stability: moved visual, UI, menu, stash, and diagnostics plugins out of the headless client load path."
        moved = $moved
        missing = $missing
    } | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $disabledRoot "disabled-manifest.json")
}

Write-Host "Headless plugin cleanup complete."
Write-Host "HeadlessRoot: $HeadlessRoot"
Write-Host "Moved: $($moved.Count)"
Write-Host "Already absent: $($missing.Count)"
if (-not $Preview) {
    Write-Host "Disabled folder: $disabledRoot"
    Write-Host "Restart FikaHeadlessManager.exe before testing again."
}
