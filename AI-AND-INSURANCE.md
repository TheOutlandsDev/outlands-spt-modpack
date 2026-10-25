# Headless population and unavailable insurance fixes

The headless host had no MainPlayer, causing SPT 4.0.13 to choose the default
18-bot limit on every map. Outlands.ScavWar 1.1.0 resolves this exact fallback
request using the registered headless session's current Fika match map cap.
Human/named-map calls and missing match state keep their native behavior.
The existing map caps and wave timing remain unchanged.

FikaDynamicAI range is 350 metres, formerly 175, with High scanning and snipers
exempt. More distant fights can continue; actual outdoor performance needs a
raid benchmark. The existing SAIN hearing/sight/accuracy settings stay unchanged.

Outlands Remote Quests 1.0.3 skips the insurance step before constructing its
empty trader dropdown when no insurer is available. It follows the native Next
path and retains map/access-key checks. Available insurers retain normal UI.
No insurance is purchased and no trader flags or profile data are edited.

Client pack 2026.10.24.3 changes one managed DLL. Close the game and launcher,
then use Play Outlands to sync before launching. Base EFT/SPT/Fika dependencies
are unchanged. New players use the complete 0.5.3 Client installer; independent
hosts use its matching SelfHost choice. Both require legitimate game files.

Tests cover real Fika match lookup, real SPT callback patching, native insurance
call sites, navigation with real Harmony, and existing quest/zombie guards.
Windows insurance UI and new outdoor combat pacing still need player testing.
