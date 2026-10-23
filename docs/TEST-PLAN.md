# Developer test plan

Use a disposable profile in a separate compatible test installation and preserve the installer's verified backup receipt.

1. Verify package hashes, pinned server version and EFT compatibility. Start with baseline + licensed third-party components; add co-op only when needed.
2. Confirm server startup, original mod versions and clean dependency loading. Compare AI Population Tuning's map summary to its exported per-map config. Check configured scav access and transits in actual raids.
3. Check map-based trader availability across a transit/restart. Validate the state regenerates without importing the original owner's rotation/profile data.
4. For Scav Life, enable the experimental layer and use a disposable profile. Exercise seed/reset only on that profile. Test survived/dead scav runs, cooldowns, pending-haul decisions and item-removal rejection. Confirm there is no item duplication/loss after save and restart.
5. For diagnostics/QuakeBrain, inspect local logs for bounded writer behavior and overhead. Redact identifiers before sharing output. Confirm QuakeBrain remains passive.
6. Add external SAIN/Looting Bots/other content at the recorded compatible versions individually. Record each external source/version and any conflicts; the public package does not include all private-build content/presets.
7. For Fika, verify a newly generated API key, private intended network binding and matching client/server mod files. Complete a two-PC join, raid, extract/death and save/restart cycle. Headless setup is separate and unverified.
8. Report the Outlands tag, SPT/EFT versions, selected layers, external mod versions and reproducible steps. Do not upload full profiles, certificates, credentials, raw telemetry or retail files to issues.

No checklist item above is claimed as completed gameplay testing by this release.
