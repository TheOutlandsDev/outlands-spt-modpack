# Original Outlands components

Component versions are independent of the overall modpack number. “Observed installed” means a DLL was present, not that runtime behavior was tested.

| Component | Version | Layer | Observed installed | Source |
| --- | --- | --- | --- | --- |
| AiPopulationTuning | 0.1.0 | baseline | yes | [project](../custom-tools/AiPopulationTuning/src/Codex.AiPopulationTuning/Codex.AiPopulationTuning.csproj) |
| OpenScavTransits | 0.2.1 | baseline | yes | [project](../custom-tools/OpenScavTransits/src/Codex.OpenScavTransits/Codex.OpenScavTransits.csproj) |
| CodexDiagnostics | 0.2.1 | baseline | yes | [project](../custom-tools/CodexDiagnostics/src/Codex.Diagnostics.Client/Codex.Diagnostics.Client.csproj) |
| ScavLifeFramework | 0.5.1 | experimental | no | [project](../custom-tools/ScavLifeFramework/src/Codex.ScavLifeFramework/Codex.ScavLifeFramework.csproj) |
| ScavLifeClient | 0.1.0 | experimental | no | [project](../custom-tools/ScavLifeClient/src/Codex.ScavLife.Client/Codex.ScavLife.Client.csproj) |
| QuakeBrain | 0.3.0 | experimental | no | [project](../custom-tools/QuakeBrain/src/QuakeBrain.Telemetry/QuakeBrain.Telemetry.csproj) |
| VagabondScavAccess | 0.1.1 | experimental | no | [project](../custom-tools/VagabondScavAccess/src/Codex.VagabondScavAccess/Codex.VagabondScavAccess.csproj) |
| FpvDroneParentCachePreload | 1.0.0 | experimental | no | [project](../custom-tools/FpvDroneParentCachePreload/src/Codex.FpvDroneParentCachePreload/Codex.FpvDroneParentCachePreload.csproj) |
| EscapeFromConnorBranding | 1.0.0 | experimental | no | [project](../custom-tools/EscapeFromConnorBranding/src/Codex.EscapeFromConnorBranding/Codex.EscapeFromConnorBranding.csproj) |

Additional source tools include ScavLifeConsole, diagnostics/telemetry summarizers, Scav Life debug/customization tools, and manual Fika headless helpers. Legacy build entrypoints now call the central build script without deployment. Headless scripts are source-only manual tools; they have not been run or validated against a headless server for this release. The prune helper now previews by default and requires `-Apply` to move files.

The optional branding component now displays `Outlands SPT Modpack v0.1.0-dev.1 / SPT 4.0.13`. Its assembly and namespace keep their previous technical names to avoid an unrelated identifier migration.
