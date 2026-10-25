# One private front door for Outlands SPT

Release 0.5.6 adds the read-only player page at the game dashboard's `/play/`
path. First-time users get the complete Client installer; returning players use
Play Outlands. The same page shows live backend/headless health, player totals,
launcher address, active content and maintenance. No game files or profile
operations are exposed by this page. The public download alone grants no access.

The host-kit includes `player-dashboard/hub-integration/render.py` and its
operator guide. Generate private Homepage bookmarks for the existing game
dashboard origin, merge them into the existing Hub configuration, and preserve
all current app/category/access settings. An optional exact `/spt` redirect
gives a memorable shortcut while retaining the node's valid HTTPS origin.
The prepared bundle is an integration candidate; its application and access
verification on the operator's Hub host are separate deployment steps.

Keep HTTPS/WebSockets and raid UDP direct to the game/headless host. No second
SPT instance, new tailnet grant, public Funnel or broad reverse proxy is needed
for bookmarks. A bookmark does not grant approval. Native SPT's embedded status
page and a separate Fika WebApp are different services; Fika administration
requires an independently verified matching version, authentication and roles.
Do not expose Fika API keys, profile editing, Docker or administrator controls
on the player page. This release changes the host portal/docs only: all 351
managed client files, 27 base hashes and 2504 static SelfHost hashes are unchanged.
