# Outlands file sync 1.4.0

Public bootstrap 1.4.0 / updater engine 1.2.0. The game baseline remains
2026.10.24.3 (351 managed client files, 27 verified base dependencies).

## Players

Install the matching complete 0.5.8 Client once if not already on 0.5.0/0.5.8.
Extract Play-Outlands-Public-1.4.0.zip, keep/obtain the private server-profile.json,
and run Install Play Outlands.cmd once. Thereafter use Play Outlands, with
Tailscale connected and game/launchers closed. A current installation transfers
metadata only; missing/changed files sync individually before the launcher opens.
Failed downloads or mismatches block launch. Existing bootstrap installations
are not silently self-replaced; this one-time shortcut upgrade is required.

## Independent hosts

Start with complete SelfHost 0.5.8. Overlay host-kit/player-dashboard source from
this archive onto the corresponding dashboard source folder; keep deployment/
config, secrets, private profile and runtime outside the public source. Configure
your private Tailscale HTTPS origin using server-profile.json. Source includes
server-profile.example.json only; do not use its inert example as a real host.
The public publisher bundles the example/profile-capable updater, so distribute
your host's real profile separately.

Review the existing client inventory against your activated compatible runtime.
Run `python3 player-dashboard/ops/publish-client-bundle.py --bundle-version
2026.10.24.3 --check` from the workspace, then repeat without --check to publish.
The publisher requires the existing legacy authored two-file artifact/checksum
in deployment/downloads, matching the complete host setup. Do not recurate
unreviewed client files. Rebuild/recreate only the dashboard using its existing
Compose setup. Do not restart game services just for transport changes.

The read-only download mount serves immutable client-file-<sha256>.bin files and
client-sync-manifest.json through the existing tailnet HTTPS dashboard. No new
ports or public Funnel are needed. Keep old blobs available for in-flight old
releases. The original client-manifest.json/full pack route remains compatible
with older updaters. Do not mirror arbitrary runtime/game folders.

Local client policy still approves exact paths; new paths or removal need a
reviewed policy/installer update. Unknown DLLs are reported, never auto-deleted.
The sync engine does not repair a different EFT/SPT/Fika base. Cache and backups
are retained. Partial-byte HTTP resume and updater self-replacement are not
implemented. Windows PowerShell 5.1/desktop behavior requires real Windows testing.

## Verification

Run `python3 -m unittest discover -s host-kit/player-dashboard/tests -v` and the
client-updater/tests.ps1, tests-sync.ps1 and tests-shortcut.ps1 PowerShell scripts.
Portable tests cover selective transfers, bad bytes, cache reuse, stopped-game
checks, rollback and a changed release before launch; they do not prove Windows
filesystem or desktop behavior. No vendor payloads or private deployment data are
included in this source update.
