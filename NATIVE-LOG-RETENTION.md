# Private native warning retention — host tools 0.5.10

Fika can prune old per-raid native error logs when the headless client starts.
The existing maintenance worker copies the newest eligible native errors.log
and maperrors.log files into its private deployment directory every tick and
before/after a controlled headless stop. It never alters the original logs.

The archive keeps at most eight sessions, two files per session and the last
512 KiB of each file (8 MiB of log payload plus bounded metadata). Oversized
files retain an explicitly marked byte tail. Session directories use mode 0700
and files mode 0600. Symlinks/special files are refused. Unchanged snapshots are
not rewritten. Capture failures reach the worker journal without blocking the
scheduled maintenance path. Unexpected pruning between ticks can still lose
warnings; this cannot guarantee complete forensic history.

Raw copied logs and archive manifests can contain private operational data.
Keep deployment/maintenance/native-log-archive/ private. It is not a player API,
public downloadable artifact, GitHub source folder, recovery checkpoint or
off-node backup. Only authored code/tests and this aggregate review are public.

This release changes maintenance source only. Game installer files, owner-layer
ZIP, download plan, installation lock, plugin validation policy and all human
files remain byte-identical to 0.5.9. The installer therefore still reports its
0.5.9 gameplay payload version inside the 0.5.10 host-tools package.

Self-host operators stop their maintenance timer/service during the source
update, save the previous source, copy the complete matching maintenance source
and dependencies from this host-kit, run the isolated tests, then resume their
existing schedule. Follow host-kit/player-dashboard/maintenance/README.md for
the deployment-specific commands. This does not require restarting the game or
backend/headless containers. Operators supply their own private deployment and
network configuration. Do not overwrite a running live installation blindly.

See POST-0.4-RAID-REVIEW.json for observed headless performance and remaining
limitations. The tool preserves evidence; it does not fix inventory transactions
or prove that an animation warning disappeared.
