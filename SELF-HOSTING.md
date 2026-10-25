# Host your own Outlands setup

You may run your own independent server using the public original code and
installer. You do not need access to the maintained Outlands server to self-host.
Your players still need legitimate compatible game/SPT installations and matching
versions. Downloaded third-party mods retain their individual terms.

## Reconstruct the public baseline

Follow [installer setup](../installer/README.md), choose **SelfHost**, and use its
matching release ZIP, author-download plan and installation lock. Supply your
own compatible SPT 4.0.13 / EFT 0.16.9.40087 base. Keep the game, installer cache,
backups and runtime separate from your public Git checkout.

The 0.5.9 reconstruction uses node-01's active 2026.10.24.3 baseline. It builds
five WTT DLLs from pinned author source; those exact builds now run on node-01.
SelfHost installs 2508 files, including the headless role, server mods and
Outlands modules. Client installs 356 files and omits headless-only plugins. Use
separate SelfHost and human Client folders. The installer applies twelve narrow
seasonal configuration changes; it never ships the game's base configuration
documents. Halloween, infected maps/fall settings, AI tuning, automatic Scav War
and remote quest acceptance with local-only turn-ins match the hosted setup.

The included host kit supplies the dashboard, maintenance/updater source and
Docker references. Prebuilt original modules and fixed policies are already in
the installer; rebuilding authored code is optional development work. Changing
DLLs or managed settings creates a new baseline: generate and review a new human
inventory, updater policy and server role policy together before distributing it.
Keep the supplied hashes when using the unmodified release. Four private host
identity templates must be configured for your own environment; public settings
intentionally do not include node-01's API key, profiles, host paths or addresses.

## Network and ownership

Install Tailscale on your own host and players. Configure the backend listener,
advertised server URL and headless connection for your host's interface/address.
The backend and raid host can be separate machines; each must advertise its own
reachable address. Use your own Fika headless profile and verify ownership with a
legitimate EFT install on the headless machine. Never copy another operator's
profile, API key, Wine prefix, launcher credentials or certificate private key.

Approve the users/devices that may play, and grant access only to the game
backend TCP port, raid host UDP port and read-only player portal that you choose.
The reference deployment uses TCP 6969, UDP 25565 and private HTTPS 8446. Keep
Docker/Dockhand/admin consoles local or operator-only. Review your Tailscale
policy: membership alone is not the intended authorization boundary. This guide
does not change firewall, Tailscale settings, account roles or access grants.

Start the backend, confirm the approved mod/policy load output, then start the
headless client and wait for Ready. Publish your private connection profile only
to approved players. Make profile/config backups before changing versions. Test
local launch, a remote player, asset transfer, a shared Ground Zero raid,
extraction/save persistence, headless relaunch and a second raid.

References: [Fika headless requirements](https://wiki.project-fika.com/advanced-features/headless-client/remote-headless-client),
[Tailscale device approval](https://tailscale.com/docs/features/access-control/device-management/device-approval),
[machine sharing](https://tailscale.com/docs/features/sharing), and
[access controls](https://tailscale.com/docs/features/access-control).
