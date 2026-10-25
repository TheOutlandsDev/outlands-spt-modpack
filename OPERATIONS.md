# Rotating operations — Client and SelfHost 0.5.7

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
SelfHost changes one server DLL plus dashboard/maintenance source. Hosts use the
new full SelfHost install for a new installation, or stop at an idle boundary,
back up and deploy the included matching authored event source/DLL and host-kit
source update. Event DLL/settings are now explicitly covered in daily checkpoints.

Calendar/policy checks, read-only API/HTTP tests, maintenance/recovery tests and
an isolated backend startup passed. The live backend/headless restarted and
passed native plugin validation. Real encounter feel, client UI, fresh Windows
installation, extraction/saves and a shared Ground Zero raid still need players.
See host-kit/player-dashboard/mods/live-content/README.md for exact modifiers.
