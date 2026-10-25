# Client update announcements and release checks — 0.5.4

Whenever a committed server publication changes any of the 351 managed client
paths, sizes or SHA256 hashes, its durable outbox queues this Fika notification:

> Client files changed (version). Finish your current raid, then close Escape
> from Tarkov AND SPT Launcher and run Play Outlands before your next raid.

The dashboard keeps these instructions visible. The existing maintenance worker
retries failed notification delivery; successful delivery is deduplicated. A
routine restart, ZIP transport change or server-only update creates no false
client-update warning. There is no extra Codex monitor or public control endpoint.

Outlands.ClientPackPolicy 1.2.0 records each authenticated session's successful
native Fika DLL report against the current managed-content identity. The private
bounded records survive an unchanged daily restart. Changed client content makes
existing records stale: new headless starts and raid joins are refused with update
instructions until the game starts fresh and validates again. Existing raid
traffic/saves and reconnects to the same active match remain available. Never
publish or redistribute validated-sessions.json; fresh installs start without it.

Play Outlands performs the full managed-file SHA256 verification before launch.
The admission record is not a hash report from a running game's config files, a
cryptographic process identity, or anti-cheat. Manually reopening correct DLLs
with old config files could still pass native Fika checking; always use Play
Outlands. No client is force-closed and no profile data is changed.

Hosts use the included matching policy/owner-layer and authored source. Generate
the fixed policy and preflight downloads before changing a DLL baseline, wait
for all raids to finish, back up, and restart the matched backend/headless pair.
Publish with host-kit/player-dashboard/ops/publish-client-bundle.py; it moves the
release fingerprint before the sync manifest and queues the notice after commit.
The first guard installation requires one fresh game startup because prior
servers did not retain native validation records. See the included policy README.

This is a server/dashboard update: client pack 2026.10.24.3, sync bundle
2026.10.24.4, Remote Quests 1.0.3 and all 351 managed/27 base hashes are unchanged.
Matching existing players close game/launcher and use Play Outlands normally;
new players use the complete Client installer. SelfHost has two changed server
files and the improved host-kit. Client/SelfHost counts remain 356/2508.

Verified: 52 backend/publisher/notice tests, 25 maintenance tests, 49 policy,
real-Harmony callback and frozen-client refusal-contract checks, and isolated
backend startup. Exact Windows update dialog rendering and a release transition
with two human players remain to be tested. The 0.5.3 AI/insurance gameplay checks
remain outstanding where documented; no new combat performance claim is made.
