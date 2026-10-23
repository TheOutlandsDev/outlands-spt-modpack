# Playing Outlands SPT

This setup targets SPT **4.0.13**, EFT **0.16.9.40087**, Fika client **2.2.5.0** and Fika server **author release 2.2.4** (assembly file version 2.0.9). Obtain a legitimate EFT installation and compatible SPT separately. The package has no retail game or base SPT runtime. Do not replace a working install with latest mod releases: use the versions and file hashes in `setup-lock.json`.

## Join the existing server over Tailscale

1. Use a separate compatible SPT installation. Get the **Client** files listed in the lock: client plugins, their assets and gameplay settings. The author installer fetches the pinned files directly and requires local imports for the source gaps in MANUAL-FILES.json.
2. Install Tailscale from https://tailscale.com/download and have the server owner grant the intended device access privately. No invite link, auth key or private address is published here.
3. Ask the server owner for their exact backend URL, including protocol and port. Put that URL in your launcher settings. Do not use `127.0.0.1` to connect to a different PC. This document does not generate or share accounts or passwords.
4. If your PC **hosts a raid**, set Fika's F12 > Fika Core > Network > **Force IP** to **your own PC's Tailscale IPv4**, and **Force Bind IP** to your own Tailscale interface address (or its supported all-interface default). The backend server address and raid host address can be different. Do not put the backend's IP in another PC's Force IP. Tailscale normally avoids router port forwarding; verify the relevant application access in your own firewall/tailnet policy.
5. Connect to the existing backend; create/use your own profile through its launcher. Your local SPT server need not run for this join mode. Wait for the server's mod bundles to synchronize if required, then join the same lobby/map and test spawning and extraction.

The snapshot preserves all observed client assets (including HollywoodFX and WTT client menu assets). Server bundle trees are in the **SelfHost** set. SPT has `/singleplayer/bundles` and `/files/bundle` endpoints; an actual remote first-connect bundle transfer has not been tested by this export. The client set's hashes cover the client plugin/config tree, not the generated bundle cache. If the server or a mod requires an additional local asset, resolve that before calling the setup playable. Do not claim a first-connect test from a successful file audit.

## Set up your own server

1. Use a separate compatible SPT install with enough free space. Use **SelfHost**, which includes both client and server mod trees, all preserved assets and sanitized gameplay settings. Keep the same layout; do not flatten `SPT/user/mods` into `BepInEx/plugins`.
2. The installer fetches SVM directly from its author with the other pinned downloads. The remaining source gaps are listed in `MANUAL-FILES.json`; supply those exact originals locally. `download-plan.json` is the authoritative list of author release/commit pins. `mod-downloads.json` records the observed assembly metadata and current provider coverage; those metadata versions can differ from release names.
3. In `SPT/user/mods/fika-server/assets/configs/fika.jsonc`, replace sanitized loopback values under `server.SPT.http`: choose the local interface `ip`, and set `backendIp` to the address your players can reach. Set the listening/advertised ports consistently. For a Tailscale-only host, use that host's own Tailscale IPv4 as appropriate. Keep API keys, admin IDs, webhooks and account data private. The exported API key is empty; let the installed Fika server generate a new one. Generated profiles, certificates, relations and state are intentionally absent.
4. Start your backend, check its mod load output and create fresh accounts. Connect the local client to your backend. Anyone hosting raids must also configure their own Fika network adapter as above.
5. Back up saves before changes. Test a local launch, a remote Tailscale join, mod asset loading, a shared raid and extraction before advertising a verified playable download.

## Use the author installer

Use **Start-Outlands.cmd** or the commands in **README.md**. A complete verified stage is required before installation. The old 0.2.0 file tools and their commands are historical and are not the entrypoint for this installer.

Original gameplay was owner-reported. This export was not launched or tested in a remote raid.
