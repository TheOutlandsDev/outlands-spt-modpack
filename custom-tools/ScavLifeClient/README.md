# Codex Scav Life Client

Small BepInEx client panel for Scav Life.

- Toggle: `F8`
- Refreshes `/singleplayer/scavlife/stash/status`
- Shows survived scav pending hauls and stored Scav Life stash item trees
- Moves a pending haul to Scav Life stash only through the server route, which refuses the move unless matching PMC profile items can be removed first

Build and install:

```powershell
cd C:\SPT
pwsh -ExecutionPolicy Bypass -File .\custom-tools\ScavLifeClient\Build-ScavLifeClient.ps1
```


Public package note: installation paths in legacy examples are placeholders. Use the central build/install scripts described in the root README. Headless setup scripts are manual tools; they are not run by the package installer.
