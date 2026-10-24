# The Outlands SPT 0.5.1 — matching node-01

**[Download Client + SelfHost 0.5.1](https://github.com/TheOutlandsDev/outlands-spt-modpack/raw/refs/heads/main/The-Outlands-SPT-0.5.1.zip)**

The current public download reconstructs node-01's active **2026.10.24.2** mod
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

**Existing 0.5.0 players: use Play Outlands to fetch this managed update.** New players and pre-0.5 users run the full 0.5.1 Client installer once. The WTT base
patcher changed; the updater deliberately stops on an old base rather than
replacing it silently. The installer backs up overwritten files/profiles and
quarantines only exact recognized older-release leftovers. Unknown DLLs stop
installation for review.

Client installs **356 files**; SelfHost installs **2508**. The installer downloads
pinned author payloads and builds five WTT DLLs from pinned source. Those exact
builds now run on node-01. No manual mod imports or global SDK are required.
Play Outlands **1.3.0** and original source/tests are included.
[The separate bootstrap](https://github.com/TheOutlandsDev/outlands-spt-modpack/raw/refs/heads/main/Play-Outlands-Public-1.3.0.zip)
is for already-matching installations and requires the host's private profile.

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

[Checksums](SHA256SUMS) · [Publication record](PUBLICATION-0.5.1.json) ·
[Earlier release history](https://github.com/TheOutlandsDev/outlands-spt-modpack/releases)
