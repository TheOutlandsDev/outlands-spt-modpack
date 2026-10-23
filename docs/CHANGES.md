# Documented changes

## Existing custom behavior represented by this export

These descriptions come from the original source and README files present at export time. They are not a reconstructed commit history, a claim that every item was installed, or a verified diff against an upstream game/SPT release.

- **AI Population Tuning 0.1.0 (installed):** applies per-map bot-count ceilings, spawn timing/check limits, normal scav wave limits and PMC wave chances. The exported baseline configuration comes from the installed original mod, not a guessed preset. Read its actual values in `payload/baseline/SPT/user/mods/zzz-CodexAiPopulationTuning/config/config.json`.
- **Open Scav Transits 0.2.1 (installed):** opens configured scav-access maps, enables existing permitted transit routes, excludes specified unfinished maps/transits, and adds configurable map-based trader availability. Current config lists Streets, both Ground Zero variants and Labs for scav access. Generated trader-rotation state is not included.
- **Codex Diagnostics 0.2.1 (installed):** captures structured local performance/plugin/scene/error and raid-context diagnostics with a bounded background writer. Captured sessions are excluded from this export.
- **Scav Life Framework 0.5.1 (optional research):** persistent scav state, survived/dead run handling, cooldown/progression settings, dossier/raid-plan routes, stash/pending-haul handling, customization and debug routes. Source includes an item-removal guard for moving selected hauls; its correctness still needs disposable-profile gameplay tests.
- **Scav Life Client 0.1.0 / Console (optional research):** an F8 client panel plus a local browser dashboard for Scav Life, installed build state, trader rotation and diagnostics summaries.
- **QuakeBrain Telemetry 0.3.0 (optional research):** passive raid/combat/line-of-sight capture and optional utility scoring. Source explicitly says it does not change bot behavior. Source README lists later AI/ML behavior stages as plans, not completed features.
- **Vagabond Scav Access 0.1.1 (optional):** restores scav side-selection controls when Vagabond hides them; declares a soft dependency on Vagabond.
- **FPV Drone Parent Cache Preload (optional):** early compatibility handling for two FPV parent-item nodes. FPV Drone Mod itself is an external dependency and is not bundled.
- **Branding (optional):** the local source previously used a personal cosmetic name/version label. The public package changes the displayed branding to Outlands while preserving the compatible Tarkov version and component identifiers.
- **Headless helper documentation (manual tools):** describes the prior separate-server/headless setup and Customs-only RUAF/UNTAR tuning. This is historical documentation only: those mods/configuration fixes were not established as active in the inspected baseline and are not installed by this package.

## Changes made to create 0.1.0-dev.1

- Defined the public name, package number and tag; pinned the observed SPT, server commit, Tarkov and major dependency versions in `manifests/build.json`.
- Exported nine original C# projects plus supporting scripts/dashboard source; omitted build caches, debug symbols and private runtime output.
- Changed assembly reference paths to `$(SptRoot)` and made the build script accept a local compatible installation. Compilation copies only each original output DLL into the package.
- Replaced hardcoded deployment build scripts with central-build wrappers. The original live installation is not an automatic build destination.
- Made the dashboard and diagnostics summarizer accept `-SptRoot`. Changed machine-specific examples to generic paths, removed local profile IDs/VPN addresses, and changed personal default scav names to `Outlands Test Scav`.
- Made the legacy headless prune tool preview by default. Other headless helpers remain explicit manual tools and are not invoked by the installer.
- Split baseline, experimental, third-party and co-op payloads. The three original baseline DLLs were observed installed; the six experimental projects were not.
- Kept third-party binary bytes unchanged. Preserved MIT, CC and dependency notices. Imported BigBrain/UI Fixes MIT notices from the exact source commits embedded in the installed assembly metadata.
- Removed per-player StatTrack data, Fika relations/friend-request state, generated headless scripts, caches, certificates, logs, profiles and captured telemetry.
- Sanitized Fika settings: empty API key/admin IDs/webhook URL, loopback server addresses, no generated headless profiles/scripts, no original VPN address. The installed-version ConfigService source was checked and generates a fresh API key when the value is empty.
- Omitted the Enable Labyrinth background image pending separate image provenance. Its code/config/license remain included; that optional image may be absent in its web UI.
- Added hash manifests, read-only verification, preview/install tooling, verified backups and install receipts. Added explicit distinctions between source builds, fixture checks and unperformed gameplay/multiplayer tests.

## Limits on historical attribution

There is no complete original revision history in this export and most installed third-party binaries were not compared byte-for-byte against upstream release downloads. Assembly versions and source-commit metadata are evidence, not a proof of an unchanged upstream binary. No undocumented edit is attributed to Outlands. Modified presets for permission-unresolved external mods are not published as cleared derivatives. The full private build therefore cannot be reconstructed from this package alone.
