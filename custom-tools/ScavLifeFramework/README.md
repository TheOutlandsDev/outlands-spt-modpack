# Scav Life Framework

Small testable server-side framework for a future persistent scav mode.

Current scope:

- Creates a persistent state file at `SPT/user/mods/000-ScavLifeFramework/data/scav_life_state.json`.
- Creates/uses config at `SPT/user/mods/000-ScavLifeFramework/config/config.json`.
- Adds framework routes:
  - `/singleplayer/scavlife/ping`
  - `/singleplayer/scavlife/status`
  - `/singleplayer/scavlife/dossier`
  - `/singleplayer/scavlife/raid-plan`
  - `/singleplayer/scavlife/debug/seed`
  - `/singleplayer/scavlife/debug/complete-run`
  - `/singleplayer/scavlife/debug/reset`
  - `/singleplayer/scavlife/customization/options`
  - `/singleplayer/scavlife/customization/apply`
  - `/singleplayer/scavlife/customization/randomize`

This slice observes real scav raid results after SPT/Fika saves them through `/raid/profile/scavsave`.
It does not change the generated player scav before raid by default.

- Survived run keeps the same scav alive and ready.
- Failed run marks the scav dead and schedules replacement after cooldown.
- State persists across server restarts.
- The dossier tracks survival streak, trust, stress, fatigue, and last raid outcome.
- The raid plan returns a suggested map, risk level, extraction style, objectives, avoid list, and loadout preference plan.
- Debug routes remain available for local testing, but the console now expects real post-raid capture.

Run the smoke test with PowerShell 7:

```powershell
pwsh -ExecutionPolicy Bypass -File C:\SPT\custom-tools\ScavLifeFramework\Test-ScavLifeFramework.ps1 -ProfileId local-test
```

Use your real profile id when you want the framework state keyed to your player profile:

```powershell
pwsh -ExecutionPolicy Bypass -File C:\SPT\custom-tools\ScavLifeFramework\Test-ScavLifeFramework.ps1 -ProfileId local-test
```


Public package note: installation paths in legacy examples are placeholders. Use the central build/install scripts described in the root README. Headless setup scripts are manual tools; they are not run by the package installer.
