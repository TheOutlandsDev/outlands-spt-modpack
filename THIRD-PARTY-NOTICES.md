# Third-party notices

The Outlands name identifies this development export. Original third-party authors retain ownership of their mods. No endorsement or authorship transfer is implied.

## Bundled MIT components

- **DrakiaXYZ:** Waypoints 1.8.2 (including author-supplied custom navmesh bundles), BigBrain 1.4.0. Waypoints license is retained alongside the plugin. BigBrain's installed-commit MIT notice is under `licenses/third-party/BigBrain.LICENSE.txt`. Sources: https://github.com/DrakiaXYZ/SPT-Waypoints and https://github.com/DrakiaXYZ/SPT-BigBrain .
- **acidphantasm:** Enable Labyrinth (client/server), Simple Workout QTE (client/server), Temporary Fixes (client), StatTrack (server). Local MIT notices are retained in each payload directory. StatTrack player data is excluded. The Labyrinth web background image is excluded pending separate image provenance. Local configuration values are preserved after sanitization; unknown binary modifications are not claimed as upstream originals.
- **Orion:** Level Endurance and Strength. MIT notice retained alongside its plugin.
- **Tyfon:** UI Fixes 5.3.8 client, networking DLL and server mod. Installed-commit MIT notice under `licenses/third-party/UIFixes.LICENSE.txt`. Source: https://github.com/tyfon7/UIFixes .

MIT notices permit redistribution/modification while requiring preservation of copyright and permission notices. They are retained unaltered. The binary payload is copied byte-for-byte from the installed copy; this release does not claim an upstream release-archive checksum match.

## Optional Fika co-op layer

**Project Fika** client 2.2.5.0 and server 2.0.9 are distributed under the installed **CC BY-NC-SA 4.0** licenses. Retained license files are under `payload/coop/BepInEx/plugins/Fika` and `payload/coop/SPT/user/mods/fika-server`. The client/server DLLs, author-provided supporting locales/image and notices are retained; per-player state and generated scripts are excluded.

Sources: https://github.com/project-fika/Fika-Plugin and https://github.com/project-fika/Fika-Server-CSharp . License: https://creativecommons.org/licenses/by-nc-sa/4.0/ .

This is a noncommercial development/testing distribution. Attribution and license notices must remain. Share adaptations of these files under the required same/compatible terms. The Fika configuration is an adaptation: API key/admin IDs/webhook/VPN settings were removed or reset and default exposure was narrowed to loopback; see `docs/CHANGES.md`. This adapted configuration remains under CC BY-NC-SA 4.0. The Outlands MIT license does not supersede it.

Fika's separate bundled notices cover K40s LZ4, LiteNetLib, Mirror and Open.NAT under MIT, SIT under NCSA, and its server's SPT/LiteNetLib notices. All supplied notices are retained with the corresponding component; do not discard them when redistributing.

## External dependencies and exclusions

SPT base software is not rebundled. Its C# server and launcher carry different licenses; obtain a legitimate matching distribution and keep its notices. Official references: https://github.com/sp-tarkov/server-csharp/blob/main/LICENSE and https://github.com/sp-tarkov/launcher/blob/master/LICENSE.md .

**SVM** is not bundled: the reviewed upstream PUSL forbids original or modified redistribution without permission. Source/license: https://github.com/GhostFenixx/svm-csharp/blob/main/LICENSE .

**FikaDynamicAI and MergeConsumables client/server** are not bundled: the installed CC BY-NC-ND 4.0 notices do not allow sharing adaptations. Installed copies were not established as pristine upstream releases. License terms: https://creativecommons.org/licenses/by-nc-nd/4.0/ .

SAIN, Looting Bots, WTT content, and other permission-unresolved components remain external. The detailed audit is in `docs/MODS.md`. Their presence in the inventory grants no redistribution permission. EFT game files/assets, certificates, player data and captured telemetry are excluded.
