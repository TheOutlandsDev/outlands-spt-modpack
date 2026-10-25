# Moderate AI spawn preset

Adjusts the existing Codex AI Population Tuning configuration, rather than
stacking a second change in base SPT configs. Effective active bot caps gain
four on larger maps and two on Factory/Ground Zero. Reserve 30→34, Customs 28→32,
Woods 33→37, Ground Zero 17→19 (high-level 18→20), Factory 12→14 and Labs 19→23.

Eligible normal Scav waves gain one slot where group caps allow: four on small
maps and up to five on larger maps. Disabled zero-slot waves remain disabled.
Existing PMC reinforcement timing/chances, bosses, zombie settings, AI difficulty,
loot/economy and Scav War are unchanged. Caps are ceilings, not a guarantee of
the number alive. Watch combat pacing and hosting performance before raising them.

Only SPT/user/mods/zzz-CodexAiPopulationTuning/config/config.json changes on the
host. The complete 0.5.2 SelfHost lock and owned settings payload include it.
Existing hosts can update with the complete matching SelfHost installer, or
review the exact authored config in custom-tools/AiPopulationTuning/config/ and
replace that single server file after stopping at an idle boundary and making
a verified backup. The fingerprint-checked spawn_preset.py helper validates
known baseline/preset configs without writing them. Do not restart during a raid.
Clients relaunch after activation to refresh cached map/raid settings. No client
DLLs, base dependencies or base SPT configs change; client pack 2026.10.24.2 stays
compatible. MoreBots' separate cap bonus remains zero.
