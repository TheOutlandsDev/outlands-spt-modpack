# Fika Server PC Headless Setup

This build is configured for one Fika headless raid host on the server PC.

## Installed headless client

- Dev PC headless client folder created by Fika Installer: `C:\SPT_HEADLESS`
- Server PC target SPT folder: `C:\SPT`
- Server PC target headless folder: `C:\SPT_HEADLESS`
- Headless profile ID: `local-test`
- Headless backend URL: `https://127.0.0.1:6969`
- Server PC launch manager: `C:\SPT_HEADLESS\FikaHeadlessManager.exe`
- The SPT server runs from the main install: `C:\SPT\SPT\SPT.Server.exe`

## Network target

- Radmin/VPN server PC IP: `127.0.0.1`
- Headless manager backend URL: `https://127.0.0.1:6969`
- Fika raid UDP port: `25565`

## What is already configured

- `SPT/user/mods/fika-server/assets/configs/fika.jsonc`
  - `server.SPT.http.ip` and `backendIp` listen on `0.0.0.0`
  - `headless.profiles.amount` is `1`
  - `headless.scripts.generate` is `true`
  - `headless.scripts.forceIp` is `https://127.0.0.1:6969`
  - `headless.restartAfterAmountOfRaids` is `1`
- `BepInEx/config/com.fika.core.cfg`
  - `Auto Use Headless = true`
  - `Force IP = 127.0.0.1`
  - `Force Bind IP = Disabled`
  - `UDP Port = 25565`

## Server PC first-run order

1. Put this SPT build on the server PC at `C:\SPT`.
2. Start Radmin VPN on the server PC and confirm its Radmin IP is `127.0.0.1`.
3. Start `SPT.Server.exe` once from the `SPT` folder.
4. Let Fika generate the headless profile and launch scripts.
5. Create/install the separate Fika Headless client folder at `C:\SPT_HEADLESS` with Fika Installer's Headless option.
6. In the headless client folder, check `BepInEx/config/com.fika.core.cfg`:
   - `Force IP = 127.0.0.1`
   - `Force Bind IP = Disabled`
   - `UDP Port = 25565`
7. Start the SPT server.
8. Start the Fika headless client/manager from the headless install.
9. In game, host a raid with `Use Headless Host` enabled.

## Notes

- One headless client can host one raid at a time.
- If Headless Manager throws a backend SSL connection error, make sure `C:\SPT_HEADLESS\HeadlessConfig.json` uses `https://127.0.0.1:6969`, not the Radmin IP.
- Leave `amount` at `1` until the server PC is stable. Increase it only if you want multiple concurrent raids and the server PC has enough CPU/RAM.
- Headless should not get every client-side visual/UI/performance mod. Keep it lean: Fika, required dependency mods, and in-raid AI/spawn mods only.
- After the headless profile is generated, you can rename it by adding its profile ID to `headless.profiles.aliases` in `fika.jsonc`.
- The dev PC headless install has a disabled-plugin manifest at `C:\SPT_HEADLESS\_codex_disabled\headless-client-ui-visual-20260509-1156\BepInEx\plugins\disabled-manifest.json`.
- On the server PC, use `C:\SPT\custom-tools\FikaHeadless\Install-FikaHeadless-ServerPC.ps1` to recreate the headless install with `C:\` paths.

## CLI command used

The dev PC headless install was created from `C:\SPT_HEADLESS` with:

```powershell
.\Fika-Installer.exe install headless --path C:\SPT --method Symlink --profileId local-test
```

On the server PC, use:

```powershell
cd C:\SPT
powershell -ExecutionPolicy Bypass -File .\custom-tools\FikaHeadless\Install-FikaHeadless-ServerPC.ps1
```

## Prune headless-only client plugins

If `C:\SPT_HEADLESS\BepInEx\LogOutput.log` shows `HollywoodFX`, `HollywoodGraphics`, UI fixes, stash helpers, or other client-only plugins loading in the headless client, stop Headless Manager and run:

```powershell
cd C:\SPT
powershell -ExecutionPolicy Bypass -File .\custom-tools\FikaHeadless\Prune-FikaHeadlessClient-ServerPC.ps1
```

This moves visual/UI/menu/stash/diagnostic plugins into `C:\SPT_HEADLESS\_codex_disabled` and writes a manifest so the change is reversible.

## Repair profile ID mismatch

If Headless Manager says it cannot find `HeadlessConfig.json` or reports the config is for the wrong/expected profile ID, run:

```powershell
cd C:\SPT
powershell -ExecutionPolicy Bypass -File .\custom-tools\FikaHeadless\Repair-FikaHeadlessConfig-ServerPC.ps1
```

That script detects the real headless profile ID generated on the server PC, then writes matching files to:

```text
C:\SPT_HEADLESS\HeadlessConfig.json
C:\SPT\SPT\user\mods\fika-server\assets\scripts\<detected-profile-id>\HeadlessConfig.json
```

If you already know the expected profile ID from the error message, pass it explicitly:

```powershell
powershell -ExecutionPolicy Bypass -File .\custom-tools\FikaHeadless\Repair-FikaHeadlessConfig-ServerPC.ps1 -ProfileId THE_EXPECTED_PROFILE_ID
```

## Radmin IP not shown

If Headless Manager says it cannot find the correct IPs and only shows the normal local LAN IP, check that Radmin VPN is running before Headless Manager starts:

```powershell
Get-NetIPAddress -AddressFamily IPv4 | Sort-Object InterfaceAlias | Format-Table InterfaceAlias,IPAddress
```

The server PC should show `127.0.0.1`. If it does not, reconnect Radmin or use the actual Radmin IP shown by that command:

```powershell
powershell -ExecutionPolicy Bypass -File .\custom-tools\FikaHeadless\Repair-FikaHeadlessConfig-ServerPC.ps1 -RadminIp ACTUAL_RADMIN_IP
```


Public package note: installation paths in legacy examples are placeholders. Use the central build/install scripts described in the root README. Headless setup scripts are manual tools; they are not run by the package installer.
