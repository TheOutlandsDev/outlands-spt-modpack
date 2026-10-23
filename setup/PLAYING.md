# Playing Outlands SPT

This setup targets SPT **4.0.13**, EFT **0.16.9.40087**, Fika client **2.2.5.0** and Fika server **2.0.9**. Obtain a legitimate EFT installation and compatible SPT separately. The package has no retail game or base SPT runtime. Do not replace a working install with latest mod releases: use the versions and file hashes in `setup-lock.json`.

## Join the existing server over Tailscale

1. Use a separate compatible SPT installation. Get the **Client** files listed in the lock: client plugins, their assets and gameplay settings. The current public setup kit contains only part of those files; it reports the rest as missing.
2. Install Tailscale from https://tailscale.com/download and have the server owner grant the intended device access privately. No invite link, auth key or private address is published here.
3. Ask the server owner for their exact backend URL, including protocol and port. Put that URL in your launcher settings. Do not use `127.0.0.1` to connect to a different PC. This document does not generate or share accounts or passwords.
4. If your PC **hosts a raid**, set Fika's F12 > Fika Core > Network > **Force IP** to **your own PC's Tailscale IPv4**, and **Force Bind IP** to your own Tailscale interface address (or its supported all-interface default). The backend server address and raid host address can be different. Do not put the backend's IP in another PC's Force IP. Tailscale normally avoids router port forwarding; verify the relevant application access in your own firewall/tailnet policy.
5. Connect to the existing backend; create/use your own profile through its launcher. Your local SPT server need not run for this join mode. Wait for the server's mod bundles to synchronize if required, then join the same lobby/map and test spawning and extraction.

The snapshot preserves all observed client assets (including HollywoodFX and WTT client menu assets). Server bundle trees are in the **SelfHost** set. SPT has `/singleplayer/bundles` and `/files/bundle` endpoints; an actual remote first-connect bundle transfer has not been tested by this export. The client set's hashes cover the client plugin/config tree, not the generated bundle cache. If the server or a mod requires an additional local asset, resolve that before calling the setup playable. Do not claim a first-connect test from a successful file audit.

## Set up your own server

1. Use a separate compatible SPT install with enough free space. Use **SelfHost**, which includes both client and server mod trees, all preserved assets and sanitized gameplay settings. Keep the same layout; do not flatten `SPT/user/mods` into `BepInEx/plugins`.
2. SVM **must be obtained separately from its author** for a public reconstruction. Several other author-download/provenance entries remain unresolved. `mod-downloads.json` gives observed DLL versions and known author links. A null author link means the original source still needs locating; it is not a download instruction. Assembly versions are metadata, not a proof of an unchanged upstream build.
3. In `SPT/user/mods/fika-server/assets/configs/fika.jsonc`, replace sanitized loopback values under `server.SPT.http`: choose the local interface `ip`, and set `backendIp` to the address your players can reach. Set the listening/advertised ports consistently. For a Tailscale-only host, use that host's own Tailscale IPv4 as appropriate. Keep API keys, admin IDs, webhooks and account data private. The exported API key is empty; let the installed Fika server generate a new one. Generated profiles, certificates, relations and state are intentionally absent.
4. Start your backend, check its mod load output and create fresh accounts. Connect the local client to your backend. Anyone hosting raids must also configure their own Fika network adapter as above.
5. Back up saves before changes. Test a local launch, a remote Tailscale join, mod asset loading, a shared raid and extraction before advertising a verified playable download.

## File tools (PowerShell, no compilation)

Audit an installation without changing it:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\Outlands-Setup.ps1 -Action Audit -Mode Client -SptRoot 'D:\SPT'
```

Assemble from the bundled files plus locally extracted original-author downloads. Supply a new destination folder; files can be nested inside extracted author ZIPs. Only exact expected SHA-256 matches are accepted. No downloads, installation or execution of donor binaries happens automatically:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\Outlands-Setup.ps1 -Action Assemble -Mode SelfHost -DonorRoot 'D:\AuthorDownloads' -Destination 'D:\Outlands-Assembled'
```

If any required file is unavailable or customized differently, the command reports every missing path and **creates no destination**. It does not substitute the latest version or call an incomplete result ready. Locally supplied copies are not automatically cleared for public sharing.

With a complete assembled/sanitized payload, preview installation, then explicitly apply it:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\Outlands-Setup.ps1 -Action Install -Mode Client -SptRoot 'D:\SPT'
powershell -NoProfile -ExecutionPolicy Bypass -File .\Outlands-Setup.ps1 -Action Install -Mode Client -SptRoot 'D:\SPT' -Apply
```

Use `-Mode SelfHost` for both trees. Close game/server/launcher first. Install checks target versions, complete payload hashes and extra mod DLLs. It refuses extra DLLs rather than deleting them. Apply backs up profiles and overwritten files with hash verification before copying. Existing settings are overwritten by this exact snapshot; local networking still needs configuration afterward. Fresh credentials and changed connection settings will intentionally make those config hashes differ in later audits. Backups contain personal data and must stay private.

Original deployment was reported working by the owner. Export integrity checks are separate from gameplay validation. The original live install was not changed or launched during this export.

References: [Fika client network settings](https://wiki.project-fika.com/fika-configuration/client), [Fika server settings](https://wiki.project-fika.com/fika-configuration/server). Those docs may describe newer versions; the lock pins this build's versions.
