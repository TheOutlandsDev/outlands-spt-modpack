# The Outlands SPT — matching node-01

**[Download Client + SelfHost 0.5.4](https://github.com/TheOutlandsDev/outlands-spt-modpack/raw/refs/heads/main/The-Outlands-SPT-0.5.4.zip)**

The current public download reconstructs node-01's active **2026.10.24.3** mod
baseline: **351 human managed files and 27 verified base files**. Both the backend
and headless client restarted healthy after a backed-up cutover. SelfHost uses
the same server mods and gameplay settings, with private identity/network fields
left for its operator. See [the verified compatibility record](HOSTED-COMPATIBILITY.json).

1. Supply your own legitimate **SPT 4.0.13 / EFT 0.16.9.40087** installation.
2. Extract the download outside your game folder. Players run
   **Start-Outlands-Client.cmd**; independent hosts run **Start-Outlands-SelfHost.cmd**
   in a separate dedicated host installation. Follow the included installer guide.
3. Approved players obtain their private connection profile through
   [Outlands Discord](https://discord.gg/cNqhhUdFW), connect Tailscale, and then use
   **Play Outlands** every time. The updater verifies/updates the managed baseline
   before opening the launcher. Public downloads do not grant server access.

**This release changes the host only. Existing matching 0.5.3 players use Play Outlands; the 351 client files are unchanged.**

**Existing 0.5.0 players: use Play Outlands to fetch this managed update.** New players and pre-0.5 users run the full 0.5.4 Client installer once. The WTT base
patcher changed; the updater deliberately stops on an old base rather than
replacing it silently. The installer backs up overwritten files/profiles and
quarantines only exact recognized older-release leftovers. Unknown DLLs stop
installation for review.

Client installs **356 files**; SelfHost installs **2508**. The installer downloads
pinned author payloads and builds five WTT DLLs from pinned source. Those exact
builds now run on node-01. No manual mod imports or global SDK are required.
The full 0.5.4 installer includes **Play Outlands 1.4.0** for individual-file sync. Original source/tests are included.
[The separate bootstrap](https://github.com/TheOutlandsDev/outlands-spt-modpack/raw/refs/heads/main/Play-Outlands-Public-1.4.0.zip)
requires a matching base installation and the host's private profile. Install it once, then use its desktop shortcut every time. It downloads only changed/missing managed files from the host before opening SPT Launcher; unchanged clients download no mod payloads.

Halloween/zombies/fall settings, steady-fight AI tuning, automatic Scav War, and
remote quest acceptance with local-only turn-ins are preserved. A live content calendar rotates hotspots and seven theme bonuses while Halloween stays active daily. Infected AI loyalty/revenge guards are now included for all players and the headless host. Daily announced
maintenance remains 5 AM Eastern and waits for raids to finish. Independent
hosts supply their own approved Tailscale access, addresses and headless identity.

The ZIP contains the complete current installer, host-kit source, docs and tests.
**Use its matching lock and instructions.** The browsable legacy installer folders,
0.4.0 release, earlier source overlay and 1.2.0 bootstrap are historical snapshots;
they do not represent this active baseline.

Every independent staged file was hash/size checked, installation/backup/refusal
fixtures passed, and a separate SelfHost backend started successfully. A fresh
Windows install, first-connect asset transfer, and a two-player **Ground Zero**
raid with extraction/save and a second raid remain to be tested.

Retail/base SPT files, saves, credentials and private connection data are excluded.
Original Outlands code is MIT. One existing repaired **MIT Flea Simulator** DLL is
included with its corresponding source and full upstream notice; other vendor
payloads are fetched from pinned author sources and retain their authors' terms.
Do not redistribute the assembled cache/game/mod folder.

[Checksums](SHA256SUMS) · [Publication record](PUBLICATION-0.5.4.json) ·
[Earlier release history](https://github.com/TheOutlandsDev/outlands-spt-modpack/releases)

## Current file synchronization

[Download Play Outlands 1.4.0](https://github.com/TheOutlandsDev/outlands-spt-modpack/raw/refs/heads/main/Play-Outlands-Public-1.4.0.zip) · [Sync source and self-host update](https://github.com/TheOutlandsDev/outlands-spt-modpack/raw/refs/heads/main/Outlands-File-Sync-1.4.0-Source.zip)

Updater engine 1.2.0 compares the 351 approved client files with the host's
versioned manifest, downloads only missing/different files over Tailscale, verifies
SHA-256, backs up changed originals, and blocks launch on failure. Verified file
downloads survive retries. All 27 frozen base dependencies are checked. Raw
runtime paths, profiles, personal settings and server/headless files never route.
The hosted gameplay baseline is still 2026.10.24.3; this changes the transport,
not gameplay. The existing complete Client/SelfHost 0.5.4 download includes the same spawn preset. Existing 0.5.1 clients update through Play Outlands.
Self-host operators apply the source update using FILE-SYNC.md, publish their
reviewed inventory and rebuild only the dashboard. Old full-pack updaters remain
supported. A real Windows first-run test and shared raid remain outstanding.

## Moderate AI population

The earlier 0.5.2 spawn preset added four AI slots on larger maps and two on Factory/Ground Zero, plus
one extra regular Scav per eligible wave where group caps allow. Existing PMC
chances and timing stay unchanged. That spawn preset alone preserved difficulty, bosses, zombie
density, loot and client DLLs. The current 0.5.4 insurance fix changes one client DLL. Scav War remains on.
[Exact preset and host instructions](SPAWN-PRESET.md). Caps are ceilings, not a
guarantee of the number alive. This server-side preset is active on node-01 after a backed-up idle
restart; players relaunch afterward to refresh cached raid settings.

## AI and insurance fixes

Client/SelfHost 0.5.4 contains the corrected headless map-limit lookup, 350m
AI activation range and Remote Quests 1.0.3 insurance skip. Existing players
close the game/launcher and use Play Outlands to sync one changed DLL.
[Details, tests and remaining raid checks](AI-AND-INSURANCE.md).

## Automatic client update instructions

Client/SelfHost 0.5.4 includes durable in-game update notices, a dashboard reminder
and release-aware admission for stale running games. Close game and launcher and
run Play Outlands before playing after activation. [Behavior, limits and tests](CLIENT-UPDATES.md).
