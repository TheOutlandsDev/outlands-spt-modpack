Current 0.5.13 update: Scav War is off; Scavs still fight infected AI. Balanced reinforcement waves and headless combat telemetry are described in [COMBAT-CHECKS.json](COMBAT-CHECKS.json) and [SPAWN-PRESET.md](SPAWN-PRESET.md). The dated details below retain their earlier scope.

# Host-tool maintenance — 0.5.11

## Checkpoint coverage and extracted guide links — 0.5.11

Future maintenance checkpoints now explicitly include four remaining original
server modules: AI population tuning, open Scav transits, minimal hardcore and
prestige requirements. This protects their existing DLLs during recovery; it
does not change the DLLs or gameplay. Existing checkpoints are not rewritten or
retroactively expanded. The native warning archive stays private.

The extracted package README now opens its included guides correctly, points
to the internal package checksum list and links to the online publication record.
The GitHub README keeps its repository-relative links. Every local Markdown
target in the assembled ZIP is checked before the archive is accepted.

This is host-tool source and documentation only. All 86 game-installer files,
the owner layer, download plan, installation lock, plugin policies and human
files remain the frozen 0.5.9 baseline. The complete download is version 0.5.11;
its installer still reports gameplay payload 0.5.9. Existing players keep using
Play Outlands; no client update or game restart is needed for these changes.

See [current downtime checks](DOWNTIME-CHECKS.json). The dated seven-day, ritual,
headless-fix and post-raid reports retain their original scope. The previous
Ground Zero/Customs review found about 59.5 median headless FPS, remaining
159–319 ms hitches of unproven cause, and two Fika inventory failures/resync
requests with no visible inventory problems reported by the player. It cannot
prove native animation warnings disappeared because those logs were pruned.
Fresh Windows installation and shared two-player Ground Zero acceptance remain
separate tests; this maintenance release does not claim either one passed.


## Recovery rehearsal — 2026-10-26

The existing 325-file saved-state checkpoint restored over a separately verified
2,504-file pinned baseline. Two network-isolated backend cold starts passed in
27.97 and 25.89 seconds, preserving all 11 saved profile records’ inventory,
quest, skill, standing and hideout data. Production game containers kept their
identities/start times. This did not create a fresh production checkpoint.

Raw live profile files were not all byte-identical: one headless hideout timer
advanced during its existing background save, reproduced after the isolated
test ended. Its gameplay fields were unchanged; the other 190 files stayed
byte-identical. The rehearsal used no live profile mount, hardlink or probe
write. The four-module coverage fix protects future checkpoints; it does not
expand the tested older checkpoint. Manual encrypted recovery preparation
passed locally, while the previous Drive copy remains unchanged.
[Exact evidence and limits](RECOVERY-CHECKS-2026-10-26.json).

## Prior maintenance and diagnostics record

# Native warning retention — 0.5.10

The host maintenance tools now preserve a private, bounded copy of native error
logs before Fika prunes old sessions. Up to eight sessions retain two error files
each, with the last 512 KiB per file: at most 8 MiB of log payload plus bounded
metadata. Truncated files are marked. Original logs remain read only; the copies
are never served by the player dashboard or included in GitHub. This is local
diagnostic evidence, not an off-node backup or an inventory/gameplay repair.

This is a host-tool source update. The included game installer and all game/mod
payloads remain the frozen 0.5.9 baseline. No client file, DLL, plugin CRC, spawn
setting or profile changes. Existing matching players keep using Play Outlands;
no client update or game restart is needed for this change. Self-host operators
update the included maintenance source together after reviewing the host guide.

Two later headless raids measured about 59.5 FPS during established busy play:
Ground Zero 59.48 and Customs 59.51 median. No frame of one second or longer was
observed during established play. Smaller 159–319 ms hitches remain; their cause
is unproven. Loading and initial activation are reported separately. The guard
counter reached 16 and 23 with zero policy errors. Native error logs from those
raids had already been pruned, so absence of animation warnings is unverified.

Two Fika inventory errors produced failure/resync requests. The player reported
no visible inventory problems; a resync request alone does not prove recovery.
See [the aggregate raid review](POST-0.4-RAID-REVIEW.json),
[native warning retention](NATIVE-LOG-RETENTION.md) and the current
[host-tool checks](HOST-TOOLS-CHECKS.json). The older dated acceptance records
remain historical evidence. Fresh Windows installation and a shared two-player
Ground Zero acceptance run are still separate tests.


## Prior diagnostics and recovery record

# Headless animation guard and hitch diagnostics — 0.5.9

Outlands Headless Raid Diagnostics 0.4.0 skips cosmetic patrol animation checks
only for Fika headless bots and adds bounded timings around bot loading and
activation. It does not suppress warnings or replace animation callbacks. The
matching SelfHost contains the same DLL and headless plugin
validation policy. Human client files are unchanged: 351 managed files and 27
base pins. Existing matching players continue using Play Outlands.

The earlier large frame hitch occurred near spawning, which establishes timing
correlation rather than a confirmed cause. New timings are intended to identify
which work coincides with another hitch. Animation guard behavior, gunplay and frame
performance still require a new raid; this release does not claim all hitches
are fixed. No spawn, difficulty, economy or player profile changes are included.

The cultist summoning ritual stays disabled. Zombies, Halloween, Scav War,
rotating encounters, loot bonuses and optional squad challenges remain enabled.
See [the current host checks](HOST-FIX-CHECKS.json).

The dated seven-day event/recovery report belongs to 0.5.7. RITUAL-CHECKS.json
belongs to 0.5.8. Those are retained historical evidence; neither full rehearsal
was repeated for this host-only update. Fresh Windows installation and the shared
Ground Zero acceptance test remain pending.


## Prior diagnostics and recovery baseline

# Raid diagnostics and recovery — 0.5.5

The earlier 0.5.5 baseline used Outlands Headless Raid Diagnostics 0.3.0. The matching SelfHost
payload includes the same DLL, configuration and native plugin-validation policy.
The Client payload remains 356 installation files, including the unchanged 351
managed files. SelfHost remains 2508 files: 2504 exact hosted hashes plus four
sanitized host identity templates. Supply your own private network/identity values.

The read-only dashboard shows headless frame rate, frame p95, alive/active AI,
FikaDynamicAI sleeping bots, and active bots with a target. Five-second snapshots
also record bot instances created, other inactive bots, dead registered bots and
error counters. A created bot instance is stronger evidence than backend profile
generation but does not establish that a bot is alive and fighting. A target does
not prove shots or attacks. Idle FPS does not predict raid performance. A real
shared raid is still required to validate these measurements and gameplay.

The background writer has a 16-entry queue, 16 KiB snapshot limit and four rotating
8 MiB logs. No player/profile IDs or raw error text are written by these metrics.
No spawn settings, hostility, economy, gameplay or player files changed here.

The host-kit protects Fika's nested server configuration and HTTPS identity in
local daily checkpoints. Manual encryption uses standard OpenPGP AES256, checks
checkpoint integrity and decrypts the envelope before accepting it. Keep the
random recovery key separately on another device or in your password manager.
Never upload the recovery key, plaintext profiles, certificates or private configs
to GitHub. An older checkpoint may have its HTTPS certificate included as a
separate encrypted-envelope member; follow the included recovery instructions.
Cloud copies are manual: no automatic cloud-upload timer is installed.

Verified locally: 56 dashboard/backend tests, 30 maintenance/recovery tests and
10 bounded diagnostics checks. An isolated restored SPT backend passed two cold
starts and returned restored profile data, with networking disabled and no
published ports. Live game containers were untouched by the rehearsal. Headless
plugin validation and fresh idle metrics pass. A physical host reboot, shared
raid performance, Windows insurance UI and two-player release transition remain
pending; these are not claimed as tested.

Use host-kit/player-dashboard/maintenance/encrypted_backup.py --create-key once,
save the key separately, then --prepare-latest for manual backup preparation.
The result is under deployment/backups/outbox. Upload only the .gpg envelope to
your private storage. Restore into a new staging directory with recovery.py;
never point a rehearsal at live profile or game directories. Authored source is
MIT; game prerequisites and third-party dependencies remain separately licensed.
