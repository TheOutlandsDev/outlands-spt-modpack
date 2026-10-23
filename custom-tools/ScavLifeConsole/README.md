# SPT Build Dashboard

Local browser dashboard for `000-ScavLifeFramework`.

It hosts a small web UI, proxies browser JSON calls to SPT's compressed HTTPS routes,
and reads local build state for the Systems dashboard.

Current dashboard sections:

- Scav Life overview, dossier, raid plan, customization, and post-raid capture state.
- Profile health checks for invalid trader references, profile fixer flags, and PMC/scav counters.
- Build snapshot for SPT/game process status, active server mods, and client plugins.
- Core system install checks for Fika, SAIN, BigBrain, Waypoints, MoreBots, Scav Life, Open Scav Transits, QuakeBrain, and Codex Diagnostics.
- Trader rotation state from `zzz-CodexOpenScavTransits`.
- Detailed server mod, client plugin, custom tool, and disabled archive lists.
- Diagnostics and QuakeBrain telemetry summaries from `Logs`, including hitches and Unity message groups.
- Recent SPT server warning/error signals and high-volume route summary.

## Run

Start the SPT server first, then run:

```powershell
pwsh -ExecutionPolicy Bypass -File C:\SPT\custom-tools\ScavLifeConsole\Start-ScavLifeConsole.ps1 -ProfileId local-test
```

Open:

```text
http://127.0.0.1:7777/
```

## Options

```powershell
pwsh -ExecutionPolicy Bypass -File C:\SPT\custom-tools\ScavLifeConsole\Start-ScavLifeConsole.ps1 -ProfileId local-test -SptBaseUrl https://127.0.0.1:6969 -ListenPrefix http://127.0.0.1:7777/
```

Use `-NoBrowser` to prevent the launcher from opening a browser tab.


Public package note: installation paths in legacy examples are placeholders. Use the central build/install scripts described in the root README. Headless setup scripts are manual tools; they are not run by the package installer.
