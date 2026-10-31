# Scav War off and balanced reinforcement waves — 0.5.13

Scav War is disabled by the 1.2.0 Fika host policy; Scavs still fight infected AI.
Existing population caps below remain. In addition to the existing PMC schedule,
regular Scavs receive 1–2 bot reinforcement waves in 60-second windows beginning
every four minutes. Large maps have six waves through minute 24, Ground Zero
has three through minute 12, Factory has two through minute 8, and Labs has none.
These reuse valid enabled Scav zones, preserve disabled waves and difficulty,
and follow native population/placement checks. A scheduled wave is not a guaranteed
spawn when the map is full. Use the new movement and weapon-shot diagnostics
to verify real fighting. Player-visible behavior still requires a raid test.

## Population baseline retained from 0.5.12

Population module 0.2.0 and preset 2026.10.30-spawns.2 address low actual wave
population, rather than relying on a higher cap alone. Normal large-map Scav
waves now have a two-bot minimum; small maps use one. Disabled zero-slot waves
remain disabled. Opening large-map PMC patrols have at least two escorts;
reinforcements have at least one. Their chance floor is 70% before the existing
calendar bonuses, and they move earlier by at most 120 seconds. Late waves
remain late enough to cover longer raids. Factory and Ground Zero use lighter
settings, including unchanged solo probabilities on low-level Ground Zero.

| Map | Previous cap | New cap |
| --- | ---: | ---: |
| Customs | 32 | 38 |
| Reserve / Interchange / Lighthouse / Streets | 34 | 40 |
| Woods | 37 | 43 |
| Shoreline | 38 | 44 |
| Ground Zero / high level | 19 / 20 | 21 / 22 |
| Factory day / night | 14 | 16 |
| Labs | 23 | 25 |

Interchange's minimum normal Scav wave budget rises from 1 to 18; Reserve's
from 21 to 30. These are aggregate wave budgets, not simultaneous live counts.
Spawn placement, map caps, valid spawn points and the running game still decide
what actually appears. Configured generation and startup do not prove attacks.

Difficulty, aim, equipment, economy, boss and infected rules, and Scav War retain
their previous behavior. Reserve's existing raider chance boost is preserved
separately from PMC tuning. Labs gains cap room only. The 351 managed human
files and 27 base verification pins stay unchanged.

Independent hosts stop game, launcher, server and headless at an idle boundary,
make a verified backup and use the complete matching SelfHost installer. The
population DLL and config must update together. The read-only spawn_preset.py
helper refuses an unmatched DLL or unknown config drift. Do not copy only the
new config onto module 0.1.0. Existing matching players close game and launcher
and reopen through Play Outlands after activation to refresh cached map data.

Two network-isolated baseline/candidate backend starts, the actual locations
HTTP route, 1,529 cross-build checks and 231 policy checks passed. Boss, zombie,
difficulty, loot and hostname data are checked separately. Increased-population
raid performance, player-visible combat and a fresh Windows install remain
acceptance tests. See POPULATION-CHECKS.json. No gameplay claim is inferred
from backend readiness alone.
