# Playing The Outlands SPT

Target: **SPT 4.0.13 / EFT 0.16.9.40087 / Fika client 2.2.5 / Fika server author release 2.2.4**. Supply your own compatible legitimate EFT/SPT installation. Use this release's lock and downloader together.

## Join the Outlands server

1. Run **Start-Outlands.cmd**, choose **Client**, and install into a separate compatible SPT folder. This installs the client plugins, local assets and gameplay settings. No local backend is needed to join the existing server.
2. Install [Tailscale](https://tailscale.com/download) and get device access privately from the server owner. This installer does not enroll your PC, change firewall rules or distribute access keys.
3. Obtain the owner's private connection JSON. Choose **C** in the installer to preview it, then type **CONNECT** to apply the backend URL and create the webapp shortcut with verified backups. A private companion ZIP may already contain that JSON; a successful Client install then applies it automatically. Start the SPT launcher once and close it beforehand if its configuration file does not exist yet. The helper preserves existing launcher fields/account data and disables automatic login when changing servers.
4. Connect using your own server profile. Private server addresses, invites and credentials stay outside the public repository. A webapp response is separate from a successful launcher connection or shared raid.
5. If your PC **hosts a raid**, set Fika's F12 > Fika Core > Network > **Force IP** to **your own PC's Tailscale IPv4**. Use your own Tailscale interface address for **Force Bind IP**, or the supported all-interface default. The backend and raid host can be different PCs. Verify application access through your firewall/tailnet policy.
6. Wait for required server bundles to synchronize, then test a shared lobby, spawning, mod asset loading and extraction. A first remote bundle transfer and fresh shared raid have not been verified by this packaging work.

The Client lock covers the local plugin/config/assets tree. Server bundle trees belong to SelfHost and can be transferred by SPT's bundle endpoints at first connection. A successful file audit does not prove remote asset delivery. Keep Client and server releases aligned, especially when comparing the locally source-built WTT DLLs with the older deployed originals.

## Host your own server

1. Use **SelfHost** to install both client and server trees, the retained assets, the three deployed Outlands components and sanitized gameplay settings. SVM and other mods are fetched from their pinned sources automatically. Keep the observed directory layout.
2. Configure the server for your own network in `SPT/user/mods/fika-server/assets/configs/fika.jsonc`. Sanitized `server.SPT.http` values use loopback: choose the appropriate local listening interface/IP, reachable backend address and ports. For a Tailscale host, use that host's own interface/address. Keep API keys, admin IDs and webhooks private; generate new local credentials. Profiles, certificates, relations and runtime state are intentionally absent.
3. Point the local launcher and your players at your own backend. Do not apply the Outlands private connection profile to an independent self-host installation. Anyone hosting raids must configure their own Fika adapter as above.
4. Check the backend's mod load output, create fresh accounts, then test local launch, remote join, bundle delivery, a shared raid and extraction. Keep profile backups before later mod changes.

The owner reported the original setup working. This installer preserves the documented setup and uses declared local author-source builds for four unavailable DLLs; those rebuilt DLLs have different hashes from the original release binaries. File/build validation is recorded in `VALIDATION.json` and `SOURCE-BUILD-PROVENANCE.json`. It does not establish a fresh multiplayer playtest.

References: [Fika client networking](https://wiki.project-fika.com/fika-configuration/client), [Fika server settings](https://wiki.project-fika.com/fika-configuration/server). Those pages can describe newer releases; this installer uses the locked versions above.
