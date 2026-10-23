# QuakeBrain

QuakeBrain is the local AI research layer for this SPT/Fika build.

The first component is `QuakeBrain.Telemetry`, a passive BepInEx client plugin. It does not control bots yet. It records raid snapshots, shots, damage, deaths, line-of-sight checks, and lightweight utility scores so later behavior layers can make bots look more player-like without replacing SAIN, BigBrain, or Waypoints.

Telemetry output goes to:

`C:\SPT\Logs\QuakeBrainTelemetry`

Each raid writes one `.jsonl` file. Every line is a JSON object, which keeps the data easy to inspect, diff, stream, or convert into heatmaps/training data later.

## Phase Plan

1. Passive telemetry capture.
2. Offline analysis: heatmaps, encounter summaries, re-peek/rotation metrics.
3. Advisory utility brain: score hold, rotate, flank, loot, retreat, extract.
4. Controlled behavior layer: gently nudge bot decisions through BigBrain/SAIN-compatible hooks.
5. Optional ML helper: train a local model to choose intentions, not raw aiming or movement.



Public package note: installation paths in legacy examples are placeholders. Use the central build/install scripts described in the root README. Headless setup scripts are manual tools; they are not run by the package installer.
