# Join the approved Outlands server

1. Join [Outlands Discord](https://discord.gg/cNqhhUdFW) and ask for SPT access.
   Wait for maintainer approval. A GitHub download, Discord membership or an SPT
   account does not itself approve a device for the hosted server.
2. Supply your own legitimate compatible EFT/SPT installation. The maintained
   baseline is SPT 4.0.13, EFT 0.16.9.40087, Fika Core 2.2.5 and the exact mod set
   supplied by the approved host. Never install SPT over the retail BSG game.
3. Install [Tailscale](https://tailscale.com/download). The maintainer privately
   provides the appropriate machine share/invite and access approval. Do not
   publish invites, auth keys, email addresses, device IDs or access screenshots.
4. Download the complete **0.5.9** package, extract it outside the game folder and
   run **Start-Outlands-Client.cmd**. It reconstructs the same human baseline as
   node-01: 351 managed files plus the five required mod dependencies/patchers.
   Run this installer once even if you used the older bootstrap: the WTT base
   patcher changed. An updater-only run correctly refuses that old base.
5. The installer includes Play Outlands 1.4.0. You may also download Play Outlands from the public [host kit](../host-kit/README.md) or the
   approved host's private dashboard. Public bootstrap users need the host's
   private `server-profile.json` beside the updater; it is not a password or an
   access grant. Use the host's matching reviewed policy and base-file guidance.
6. Extract the ZIP and run **Install Play Outlands.cmd** once. Select the existing
   modded SPT folder. It creates **Play Outlands** on your Windows desktop, with
   no Administrator rights. Connect Tailscale, close the game/launchers and use
   that shortcut every time. It updates/verifies approved files before opening
   SPT Launcher. Missing profile, wrong base, changed/extra DLLs or failed HTTPS
   checks stop launch. Do not override these checks to join.
7. Use the launcher URL and your own game profile provided by the approved host.
   Human players must not copy headless-only plugins or another machine's Fika
   Force IP / Force Bind IP. For this deployment select **Use Headless Host**.
8. Start with a two-player Ground Zero raid. Verify loading, AI, extraction,
   inventory/quest persistence and another raid after the headless host relaunches.

The game backend, raid UDP and dashboard remain within approved Tailscale access.
Public source/installer publication does not enable public Internet hosting or
router port forwarding. No enrollment keys or live connection endpoints are in
this guide. Send redacted troubleshooting details privately in Discord; public
issues are for reproducible code/install problems without personal data.

Existing 0.5.0 clients can receive Remote Quests 1.0.3, including the existing infected-AI rules through Play Outlands. The new infected AI guards preserve ordinary Scav consequences. Test a Ground Zero Scav extraction and verify Fence standing after killing infected; behavior still needs real play validation.

Existing 0.5.0 clients can receive Remote Quests 1.0.3, including the existing infected-AI rules through Play Outlands. The new infected AI guards preserve ordinary Scav consequences. Test a Ground Zero Scav extraction and verify Fence standing after killing infected; behavior still needs real play validation.
