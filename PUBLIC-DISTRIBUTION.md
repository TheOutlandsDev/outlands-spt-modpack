# What is public and what stays local

Outlands original SPT code, public setup scripts, reviewed factual presets,
version/hash metadata, build recipes and player/self-host documentation belong
in this public repository wherever they can be shared. The private development
archive is recovery material, not the only player distribution location.

| Public | Local or shared privately with approved players |
| --- | --- |
| Original code, tests and MIT license | Retail EFT/base SPT installations and Wine prefixes |
| Play Outlands source/bootstrap | Actual server-profile.json and game connection details |
| Pinned author-download/build recipes | Tailscale invites, enrollment/auth/API keys and admin policy state |
| Original configuration facts and example files | Passwords, tokens, webhooks, certificate private keys and launcher accounts |
| Reviewed version/path/hash manifests | Profiles, inventories, player saves, backups and raw operational logs |
| Public Discord access-request link | Assembled third-party packs unless their terms permit redistribution |

Public availability of original code is separate from approval to access the
maintained server. Approval occurs privately through the operator and Tailscale.
Self-hosting is independent: operators supply their own installations, network,
credentials and reviewed client baseline. No purchase, credentials or Tailscale
key is requested by the public bootstrap.

Original code follows the repository MIT scope. Third-party mods/artwork keep
their authors' terms. Prefer pinned author downloads or source-build recipes to
mirroring their binaries. Public hashes and source references do not grant
redistribution rights. Do not publish an assembled game/mod folder as a shortcut.

Host-kit source is derived from authored tools used on the maintained deployment,
with private endpoints removed, SDK/workspace inputs made explicit, and private
server-profile configuration added to the public bootstrap. Publishing source
does not certify an independent fresh installation or multiplayer playtest.
