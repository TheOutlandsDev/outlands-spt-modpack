# One private front door for Outlands SPT

Release 0.5.7 adds the read-only player page at the game dashboard's `/play/`
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

## Maintained Hub deployment — October 25, 2026

The four SPT cards are now live in the existing Game Operations category. The
catalog has 37 apps and retains all 33 prior entries in order. The existing
theme, navigation, app categories and direct game network paths are preserved.
The optional exact `/spt` redirect was not activated; use the Hub's Game
Operations category and Play Outlands card. No service restart or game-file
change was required.

Server-origin probes reached the node player page, status/update APIs and updater
download with verified HTTPS. A desktop Browser check confirmed the themed
category contains all eight Game Operations cards; clicking Play Outlands and
SPT Live Raids opened the live node pages with current data. This does not
establish fresh Windows installation, physical-phone behavior, two-player raid
success, or approved/unapproved player identity boundaries. Those remain tests.

The portable generator remains in the unchanged 0.5.7 package. The native Hub
checkout contains unrelated edits and sensitive inline configuration, so those
files are excluded from public publication. The bounded deployment result is
[recorded separately](https://github.com/TheOutlandsDev/outlands-spt-modpack/blob/main/HUB-DEPLOYMENT.json). Deployment flags inside the immutable
0.5.7 ZIP describe its packaging time; this current record supersedes that
operational status without changing any installer or gameplay hashes.
