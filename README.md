# Outlands SPT Modpack

**Build 0.1.0-dev.1 · SPT 4.0.13 · EFT 0.16.9.40087 · Developer prerelease**

Outlands is a public development and testing export of a customized SPT/Fika setup. It includes nine original mod projects with source, rebuilt binaries, original presets, a selected licensed third-party mod layer, and an optional Fika co-op layer. This first export separates the three original components observed in the installed baseline from six optional experimental components.

The full local mod list is recorded for developers, including components that are not redistributed. This is a curated export, not an exact copy of the full private installation. Reproducing its entire gameplay setup requires obtaining the external dependencies listed in [MODS.md](docs/MODS.md). Their availability and matching versions have not all been verified.

## Version target

| Item | Pinned value |
| --- | --- |
| Outlands package | `0.1.0-dev.1` |
| Release tag | `v0.1.0-dev.1-spt4.0.13` |
| SPT server | `4.0.13 RELEASE` |
| Installed server commit | `2891fd41fd07b6150a2192ac0d24adb93eb72862` |
| Compatible Tarkov client | `0.16.9.40087` |
| Fika client / server | `2.2.5.0` / `2.0.9` |

Versions above come from local executable/assembly metadata and SPT's compatibility configuration. The tag names this Outlands snapshot; it is not an upstream SPT release or an endorsement by SPT, Fika, Battlestate Games, or any mod author.

## Install for testing

Use Windows and PowerShell 7. Start with a separate, working SPT 4.0.13 installation made from your own legitimate compatible Tarkov copy. The base SPT runtime, BepInEx framework, Tarkov client, retail assets, and game assemblies are prerequisites and are not included.

Download the **Outlands-SPT-Modpack-v0.1.0-dev.1.zip release asset**, which contains source and binary payloads. GitHub's automatic “Source code” archives and the source repository omit binary payloads. Do not extract the package over your game folder. From the extracted package directory:

```powershell
pwsh -NoProfile -File .\scripts\Verify-Package.ps1
# Inspect the plan without writing to the installation:
pwsh -NoProfile -File .\scripts\Install-Outlands.ps1 -SptRoot 'C:\SPT-TEST' -IncludeThirdParty -IncludeCoop -Preview
# Install the baseline and cleared third-party/co-op layers:
pwsh -NoProfile -File .\scripts\Install-Outlands.ps1 -SptRoot 'C:\SPT-TEST' -IncludeThirdParty -IncludeCoop
```

The installer requires the pinned SPT/EFT compatibility versions and closed game/server processes. It verifies package hashes, rejects linked destination paths, backs up profiles and overwritten files, verifies backup hashes, and verifies installed copies. Existing configuration files are preserved unless `-ReplaceConfigs` is supplied. Use a clean test install, or consciously opt into replacing configs, for matching presets. Backups and a local installation receipt remain under `OutlandsBackups` in the test installation.

Create a disposable test profile. Test startup and one complete raid before introducing additional external mods. Keep every Fika client on matching mod versions. Network hosting, headless installation and two-PC testing require separate setup; this package defaults to loopback and does not open ports or change a VPN.

## Optional research components

`-IncludeExperimental` adds Scav Life Framework/client, QuakeBrain telemetry, Vagabond Scav Access, the FPV compatibility preload, and Outlands branding. These were not observed deployed in the inspected installation. Install them only in the separate test copy; game compatibility and save behavior still need runtime testing.

For the local dashboard, after installing experimental Scav Life and starting the SPT server:

```powershell
pwsh -File .\custom-tools\ScavLifeConsole\Start-ScavLifeConsole.ps1 -SptRoot 'C:\SPT-TEST' -ProfileId 'YOUR-TEST-PROFILE-ID'
```

The dashboard and debug routes can change test-profile state. Keep the dashboard on loopback. Diagnostics and QuakeBrain can write player identifiers and other raid telemetry locally; review and redact generated output before sharing it. No captured telemetry or profiles are included here.

## Develop from source

Install .NET SDK 9 and the .NET Framework 4.7.2 developer targeting pack for client plugins. Supply an existing compatible local SPT installation; the projects reference its assemblies without copying them into the public package.

The Git repository contains browsable source, configuration, licenses and manifests. Use `Verify-Package.ps1 -SourceOnly` to verify a source checkout. For the complete third-party/co-op binary payloads, use the release asset. GitHub Actions checks source integrity and PowerShell parsing; it does not compile against or download game assemblies.

```powershell
pwsh -File .\scripts\Build-Outlands.ps1 -SptRoot 'C:\SPT-TEST'
# Or build one original project:
pwsh -File .\scripts\Build-Outlands.ps1 -SptRoot 'C:\SPT-TEST' -Project QuakeBrain
```

Builds write intermediates to `.build` and original DLL outputs to their payload layers. They do not deploy into the supplied game installation. After any rebuild or source edit, regenerate `SHA256SUMS` with `scripts/Update-Checksums.ps1` before using the installer. Changing the checksums makes a local development package, not the unchanged published snapshot.

## What changed and what was verified

See [documented behavior and packaging changes](docs/CHANGES.md), [original components](docs/OWNED-MODS.md), [license decisions and complete local inventory](docs/MODS.md), and [verification / test plan](docs/VERIFICATION.md). The machine-readable version and provenance records are under `manifests`.

This is a developer prerelease. Source builds and package/install checks do not establish successful gameplay or multiplayer operation. No game or server was launched to prepare this release, and the inspected live installation was not modified.

## Credits and licensing

Original Outlands source, packaging code and documentation are covered by [MIT](LICENSE), consistent with the existing original server-mod metadata. Existing `Codex` technical namespaces/IDs are retained for compatibility. The custom projects were developed under the owner's direction with AI assistance; no claim is made that third-party work was authored by Outlands. See [AI-use and provenance](docs/AI-USE.md).

Third-party files retain their own authorship and licenses. **The Fika co-op layer is CC BY-NC-SA 4.0 with separate dependency notices; the root MIT license does not relicense it.** See [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md). SVM, modified ND-licensed components and components with unresolved redistribution permission are not bundled. No rights to Tarkov are granted.
