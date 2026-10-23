# The Outlands SPT 0.4.0 — SPT 4.0.13

The Outlands SPT is the owner's custom Tarkov/Fika experience, with the deployed Outlands mods and gameplay settings. This beta installer supports **Client** to join an existing Fika server and **SelfHost** for the complete client/server mod trees and assets.

It downloads pinned mod files from their authors and verified archived originals. **Four unavailable WTT DLLs are built locally from pinned, unmodified author source**, using a portable Microsoft compiler in the cache. They have new reproducible hashes and recorded comparisons with the installed originals. Read `SOURCE-BUILD-PROVENANCE.json` for the precise scope. No third-party mod binaries/assets or game files are shipped in this installer ZIP.

## Install

1. Prepare your own compatible **SPT 4.0.13 / EFT 0.16.9.40087** installation in a separate folder. Close the game, server and launcher. Keep at least 35 GB free for downloads, staging, portable build tools and installation backups, in addition to your existing game. Existing mod files/profiles can require more backup space.
2. Extract the release ZIP outside the game folder. Double-click **Start-Outlands.cmd**. Choose **1 Client** to join the Outlands server, or **2 SelfHost** to set up your own.
3. Choose **D** to download, compile and check the mod files, or **I** to install. Supply the compatible game folder when asked. Normal setup does not require manually importing mod archives or installing Python, Visual Studio or a global .NET SDK. Windows PowerShell and Windows `tar.exe` are used.
4. Installation defaults to preview. Type **INSTALL** to apply it. The tool requires every staged file to verify, checks game/SPT versions and extra DLLs, and backs up profiles plus overwritten files with hash verification before copying. It refuses unexpected DLLs rather than deleting them.
5. Follow **PLAYING.md** for Tailscale, your private server connection and the first playtest. **C** in the launcher previews/applies a private connection JSON supplied by the server owner. A private companion installer can include that profile; it must stay off public GitHub.

The original setup was reported working by its owner. The exported installer has file/build and synthetic installation checks; a fresh game launch, remote first-connect asset transfer and shared raid still need testing. The source-built DLLs are explicitly identified; they are not byte-identical upstream release archives.

## Build pins and changes

- **SPT 4.0.13**, commit `2891fd41fd07b6150a2192ac0d24adb93eb72862`; **EFT 0.16.9.40087**.
- **Fika client 2.2.5** and **Fika server author release 2.2.4**. The server's assembly file version says `2.0.9`; exact file comparison identified the matching author download as 2.2.4.
- Every archive/raw download and every staged output has a SHA-256 pin. Changed downloads or build outputs are rejected. There is no automatic selection of the latest mod release.
- The three deployed Outlands components and their existing source remain in the repository. Earlier optional research components are not installed. The already-disabled Revival artifacts are omitted. The observed nested NarcoNet deployment and other paths are preserved.
- Sanitized gameplay settings are regenerated from declarative INI/JSON facts with semantic equality checks. Formatting/comments can differ; `CONFIGURATION-PROVENANCE.json` records original/generated hashes. BotCallsigns' combined list is generated from its verified downloaded input lists.
- WTT text reconstruction recipes apply declared byte offsets to downloaded text and require an exact final hash. Source build provenance, archived repository ownership and original author attribution are recorded separately.

`BUILD-STATUS.json` gives current coverage. `download-plan.json` lists URLs, author releases/commits, build projects and hashes. `setup-lock.json` is the installation lock. `CHANGES.md` documents this release; the repository's existing `docs/CHANGES.md` records earlier documented work. Undocumented historical modifications are not invented or attributed.

## Downloads, cache and troubleshooting

The default cache is `%LOCALAPPDATA%\OutlandsSPT\0.4.0`. Downloads resume by reusing verified complete files; incomplete downloads restart. A full SelfHost reconstruction downloads about 10 GB, then stages about 11 GB. Build tools stay within the cache and do not install a global SDK or development certificate. Author project files, post-build deployment commands and package build tasks/analyzers are not executed.

If a host is unavailable, the tool reports its source ID and refuses an incomplete installation. Rerun later using the same cache. `-NoDownload` uses only verified cached inputs. `-SourceId` limits a diagnostic download; it does not waive completeness checks. Optional `-ImportRoot` accepts exact locally available files/archives, but normal reconstruction does not depend on them. An altered base reference DLL is rejected; start from the compatible SPT/EFT build.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\Install-Outlands-Authors.ps1 -Action Plan -Mode Client
powershell -NoProfile -ExecutionPolicy Bypass -File .\Install-Outlands-Authors.ps1 -Action Download -Mode Client -SptRoot 'D:\SPT'
powershell -NoProfile -ExecutionPolicy Bypass -File .\Install-Outlands-Authors.ps1 -Action Install -Mode SelfHost -SptRoot 'D:\SPT'
powershell -NoProfile -ExecutionPolicy Bypass -File .\Install-Outlands-Authors.ps1 -Action Install -Mode SelfHost -SptRoot 'D:\SPT' -Apply
```

Use `-CacheRoot` for a separate cache location. **V** audits the installed mod/config files. Network/account changes and settings later saved by mods can intentionally change their hashes. Local reports/build logs and backups can contain local paths or personal data; keep them private.

## Sharing and attribution

Share this installer ZIP and its repository. Do not republish the assembled mod cache/stage or a private companion ZIP. Downloaded mods retain their authors' terms, including Fika artwork and SVM; downloading does not grant blanket redistribution permission. Archived copies are labeled and pinned to preserved original files/commits.

The public installer contains owner outputs, factual settings and tools. It excludes retail/base SPT files, profiles, saved account credentials, API keys, webhooks, private server addresses and Tailscale access keys. The installer uploads nothing. HTTPS and author permissions are respected; it does not bypass TLS checks, sign-in, CAPTCHA, rate limits or download agreements.

See **THIRD-PARTY-NOTICES.md** for credits and license scope. The earlier 0.3.0 release required local imports; use this release's instructions and lock together.
