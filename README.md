# The Outlands SPT — Build 0.4.0 · SPT 4.0.13

## Public hosting tools and source — October 24, 2026

- **[Download the public source and hosting kit](Outlands-Public-Source-2026.10.24.zip)**: 106 reviewed source/metadata/artifact files preserving their folders. Includes the player dashboard, Play Outlands updater and shortcut, fixed client policy, remote quest acceptance with local turn-ins, Scav War, daily maintenance, Docker/Compose references, tests and join/self-host/video guides. Extract as a source overlay onto this repository checkout; start with `host-kit/README.md`. This ZIP is source and authored artifacts, not a complete game/server installation.
- **[Download Play Outlands Public 1.2.0](Play-Outlands-Public-1.2.0.zip)**: Windows updater and shortcut bootstrap. Approved players need the host's private `server-profile.json` and matching legitimate game/client installation before use. The bundled example cannot connect.
- **[Download five authored policy/plugin DLLs](Outlands-Authored-Policies-2026.10.24.zip)**: original Outlands modules, byte-for-byte equal to node-01's deployed authored DLLs at publication. Read the included installation notes; dependencies and runtime policies/configuration are separate.
- **Request access:** [Outlands Discord](https://discord.gg/cNqhhUdFW). Public downloads do not grant access; Tailscale approval and connection details are provided privately. Independent hosts use their own addresses, credentials and player approvals.

**Hosted compatibility is still pending:** the existing public 0.4.0 Client/SelfHost reconstruction differs from node-01's managed client baseline. These new authored DLLs match, but the complete public modpack does not yet match the hosted server. Do not treat the older installer as a ready-to-connect client. See [the comparison](HOSTED-COMPATIBILITY.json) and [publication record](PUBLICATION-2026.10.24.json). Fresh Windows setup and a shared Ground Zero raid remain to be tested.

This publication contains reviewed original source, sanitized examples and original deliverables. Retail/base game files, vendor mod payloads, accounts, credentials, saves, private connection profiles and live host endpoints are excluded. Original code is MIT; dependencies keep their authors' terms. SHA-256 hashes for these downloads are in [SHA256SUMS](SHA256SUMS).

## Existing public 0.4.0 reconstruction

The Outlands SPT is a custom Tarkov/Fika experience with Outlands mods, assets and gameplay settings.

**[Download the 0.4.0 installer beta](https://github.com/TheOutlandsDev/outlands-spt-modpack/releases/tag/v0.4.0-source-installer-spt4.0.13)**, extract the ZIP outside your game folder and run **Start-Outlands.cmd**. Choose **Client** to join an existing Fika server or **SelfHost** for the complete client/server mod trees and assets. Supply your own compatible legitimate EFT/SPT installation.

**No manual mod imports are required.** The installer downloads pinned author files and verified archived originals, then applies the deployed Outlands components and sanitized settings. Four unavailable WTT DLLs are compiled locally from pinned author source using a portable Microsoft compiler. No global development-tool installation is required.

Client reconstruction covers **592 files**; SelfHost covers **2,857 files**. Both modes were reconstructed from empty staging folders using verified cached original downloads, without importing installed mod files. File audits, reproducible build checks and synthetic installation/backup tests passed. **A fresh launch, remote first-connect asset transfer and shared raid still need testing.** The original live setup was reported working by its owner and was not changed by this packaging work.

- [Install and troubleshoot](installer/README.md)
- [Join over Tailscale or self-host](installer/PLAYING.md)
- [Pinned downloads and build recipes](installer/download-plan.json)
- [Source-built DLL provenance](installer/SOURCE-BUILD-PROVENANCE.json), [coverage](installer/BUILD-STATUS.json) and [validation](installer/VALIDATION.json)
- [Release changes](installer/CHANGES.md), [earlier documented changes](docs/CHANGES.md) and [custom Outlands source](custom-tools)
- [Attribution and sharing terms](installer/THIRD-PARTY-NOTICES.md)

Target: **SPT 4.0.13 / EFT 0.16.9.40087 / Fika client 2.2.5 / Fika server author release 2.2.4**. SPT commit: `2891fd41fd07b6150a2192ac0d24adb93eb72862`. The Fika server's `2.0.9` assembly metadata differs from its matching 2.2.4 author package.

The four locally built WTT DLLs have declared new hashes. Armory matches 35 client and 91 server canonical methods; its client references installed SPT reflection 4.0.13 instead of the original 4.0.11. Backport matches all 45 client methods and 78 server raw methods; the final server method matches after proven compiler-temporary normalization. Author source is unchanged apart from recorded Windows checkout line endings. These static comparisons do not establish a multiplayer playtest.

Private server/webapp addresses, Tailscale access, accounts and credentials are configured privately. The public installer ships owner outputs, factual settings and tools. It excludes retail/base SPT files, personal profiles and third-party mod binaries/assets. Downloaded files keep their authors' terms; do not republish the assembled cache/stage or a private companion installer.

The installer preserves the three deployed Outlands components and observed layout. Earlier optional experiments in `custom-tools` are development references and are not activated. The already-disabled Revival artifacts are omitted. Existing technical namespaces are retained for compatibility; [AI-use and provenance](docs/AI-USE.md) records the earlier development process.

Releases 0.2.0 and 0.3.0 are historical partial reconstruction kits. The old 0.1.0-dev.1 ZIP/checksum were withdrawn after the artwork audit. Use the current installer and its matching lock together.

