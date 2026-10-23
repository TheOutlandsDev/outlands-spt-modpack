param(
    [string] $MainSptRoot = "C:\SPT",
    [string] $HeadlessRoot = "C:\SPT_HEADLESS",
    [string] $ProfileId = "",
    [string] $RadminIp = "127.0.0.1",
    [string] $BackendUrl = "https://127.0.0.1:6969",
    [string] $BindIp = "Disabled"
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
        foreach ($configFile in Get-ChildItem -LiteralPath $scriptsRoot -Recurse -File -Filter "HeadlessConfig.json" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending) {
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
        foreach ($profileFile in Get-ChildItem -LiteralPath $profilesRoot -File -Filter "*.json" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending) {
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

$resolvedProfileId = Get-HeadlessProfileId -Root $MainSptRoot -RequestedProfileId $ProfileId
if ([string]::IsNullOrWhiteSpace($resolvedProfileId)) {
    throw "Could not detect a Fika headless profile id. Start C:\SPT\SPT\SPT.Server.exe once, let Fika generate the headless profile, then rerun this script."
}

$headlessLaunchConfig = Join-Path $HeadlessRoot "HeadlessConfig.json"
New-Item -ItemType Directory -Force -Path $HeadlessRoot | Out-Null

[pscustomobject]@{
    ProfileId = $resolvedProfileId
    BackendUrl = $BackendUrl
    StartMinimized = $false
} | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $headlessLaunchConfig

$serverScriptConfig = Join-Path $MainSptRoot "SPT\user\mods\fika-server\assets\scripts\$resolvedProfileId\HeadlessConfig.json"
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $serverScriptConfig) | Out-Null
Copy-Item -Force -LiteralPath $headlessLaunchConfig -Destination $serverScriptConfig

$headlessFikaConfig = Join-Path $HeadlessRoot "BepInEx\config\com.fika.core.cfg"
if (Test-Path -LiteralPath $headlessFikaConfig) {
    $text = Get-Content -LiteralPath $headlessFikaConfig -Raw
    $text = $text -replace '(?m)^Force IP = .*$', "Force IP = $RadminIp"
    $text = $text -replace '(?m)^Force Bind IP = .*$', "Force Bind IP = $BindIp"
    $text = $text -replace '(?m)^UDP Port = .*$', "UDP Port = 25565"
    Set-Content -LiteralPath $headlessFikaConfig -Value $text -NoNewline
}

Write-Host "Repaired Fika headless config."
Write-Host "ProfileId: $resolvedProfileId"
Write-Host "Backend URL: $BackendUrl"
Write-Host "Radmin/Fika host IP: $RadminIp"
Write-Host "Fika bind IP: $BindIp"
Write-Host "HeadlessConfig: $headlessLaunchConfig"
Write-Host "Server script config: $serverScriptConfig"
