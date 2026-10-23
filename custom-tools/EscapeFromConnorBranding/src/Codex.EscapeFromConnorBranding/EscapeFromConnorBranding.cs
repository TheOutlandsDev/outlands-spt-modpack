using SPTarkov.DI.Annotations;
using SPTarkov.Reflection.Patching;
using SPTarkov.Server.Core.Models.External;
using SPTarkov.Server.Core.Utils;
using SPTarkov.Server.Core.Utils.Logger;
using System.Reflection;

namespace Codex.EscapeFromConnorBranding;

[Injectable]
public sealed class EscapeFromConnorBranding(
    SptLogger<EscapeFromConnorBranding> logger) : IOnWebAppBuildModAsync
{
    internal const string GameName = "Outlands SPT Modpack";
    internal const string VersionLabel = "v0.1.0-dev.1 / SPT 4.0.13";
    internal const string FullLabel = GameName + " " + VersionLabel;

    public Task OnWebAppBuildAsync()
    {
        new WatermarkVersionTagPatch().Enable();
        new WatermarkInGameVersionLabelPatch().Enable();
        logger.Success($"Installed branding patch: {FullLabel}.", null);
        return Task.CompletedTask;
    }
}

internal sealed class WatermarkVersionTagPatch : AbstractPatch
{
    public WatermarkVersionTagPatch() : base("codex.escapefromconnor.branding.versiontag")
    {
    }

    protected override MethodBase GetTargetMethod()
    {
        return typeof(Watermark).GetMethod(nameof(Watermark.GetVersionTag), [typeof(bool)])!;
    }

    [PatchPrefix]
    public static bool PatchPrefix(ref string __result)
    {
        __result = EscapeFromConnorBranding.VersionLabel;
        return false;
    }
}

internal sealed class WatermarkInGameVersionLabelPatch : AbstractPatch
{
    public WatermarkInGameVersionLabelPatch() : base("codex.escapefromconnor.branding.ingameversion")
    {
    }

    protected override MethodBase GetTargetMethod()
    {
        return typeof(Watermark).GetMethod(nameof(Watermark.GetInGameVersionLabel), Type.EmptyTypes)!;
    }

    [PatchPrefix]
    public static bool PatchPrefix(ref string __result)
    {
        __result = EscapeFromConnorBranding.FullLabel;
        return false;
    }
}
