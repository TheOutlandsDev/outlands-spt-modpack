# Rotating operations — host tools 0.5.10; gameplay baseline 0.5.9

## Native warning retention and post-raid review — 0.5.10

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

## Headless animation guard and hitch diagnostics — 0.5.9

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

## Ritual disabled — 0.5.8

The cultist summoning ritual is disabled. Halloween, infected AI, autumn,
Scav War, rotating hotspots, loot bonuses and optional squad challenges stay
enabled. This changes one base server setting and the host helper default;
the 351 managed client files and 27 base pins stay unchanged. The dashboard
also recognizes Reserve's native `RezervBase` map name in raid diagnostics.

Existing matching players continue using Play Outlands. Independent hosts
stop the game, launcher, server and headless client, back up, then run the
matching SelfHost installer to apply the preset. The installer preserves
verified configuration backups and refuses conflicting custom settings.
See [the narrow release checks](RITUAL-CHECKS.json).

The seven-day event/recovery rehearsal below was performed for 0.5.7 on
2026-10-25. It remains prior-build evidence; the full rehearsal was not repeated
for this one-setting update. The event DLL and calendar settings are unchanged.

Outlands Live Content 1.1.0 adds distinct daily encounter pacing, primary and
secondary hotspot operations, four weekly campaign phases, small location loot
chance bonuses and optional squad challenges. Halloween and Scav War stay on.

The main dashboard has an interactive active/seven-day forecast, map briefings,
planned modifiers and actual startup wave-adjustment counts. Forecasts are not
active settings. Challenges are self assessed, with no persistent quest progress,
automatic tracking or extra payouts. Existing engine-managed Scav waves keep
their native timing; only eligible timed later waves can move earlier.

All changes activate once after an idle restart. Current caps, difficulty/aim,
Ground Zero event protection, trader prices and ordinary quest rewards remain.
Primary location loot chance is multiplied by at most 1.05 and secondary by at
most 1.025. Enabled PMC waves gain at most seven chance points, enabled boss
waves at most ten. Disabled waves stay disabled, early waves stay early, no wave
counts or slots are multiplied. The schedule is deterministic in Eastern time,
including DST. Delayed maintenance keeps the active plan until restart.

Matching players keep using Play Outlands: all 351 managed client files and 27
base hashes are unchanged. New players use the complete Client installer.
The prior 0.5.7 feature update changed one server DLL plus dashboard/maintenance source. Hosts use the
new full SelfHost install for a new installation, or stop at an idle boundary,
back up and deploy the included matching authored event source/DLL and host-kit
source update. Event DLL/settings are now explicitly covered in daily checkpoints.

Calendar/policy checks, read-only API/HTTP tests, maintenance/recovery tests and
an isolated backend startup passed. The live backend/headless restarted and
passed native plugin validation. Real encounter feel, client UI, fresh Windows
installation, extraction/saves and a shared Ground Zero raid still need players.
See host-kit/player-dashboard/mods/live-content/README.md for exact modifiers.

## Completed backend rehearsal — prior 0.5.7 build

All seven themes were booted with the byte-identical event DLL in an isolated
backend, using a test-only event-selection clock. Twelve map variants per day
were checked against independent expected changes and actual client/locations
HTTP output: PMC chance/timing/cap behavior, enabled boss chance, eligible Scav
windows, wave counts/slots, location loot multipliers, infection, reciprocal
Scav/infected hostility and Ground Zero protection. Boss sightings adjusted one
Reserve boss wave and three Customs boss waves. Engine-managed Scav windows
remained unchanged; ten eligible Reserve windows moved earlier on its hotspot
days. This is configured behavior, not evidence of spawned or attacking bots.

The latest local checkpoint restored 324 files, including the event DLL/settings,
and booted twice without instrumentation. Restored inventory, quest, skill,
hideout and trader-standing data stayed unchanged. No live service restart or
production edit was performed. See [the bounded rehearsal record](REHEARSAL-RESULTS.json).
The immutable 0.5.7 archive remains byte-for-byte unchanged.
