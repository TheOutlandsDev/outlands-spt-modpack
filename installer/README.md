# Outlands SPT Author Installer 0.3.0

**Beta author downloader and installer. It cannot yet reconstruct a fresh complete setup entirely automatically.** Currently **5 client files** or **226 self-host files** require an exact locally supplied original. The tool refuses to install an incomplete set. See `MANUAL-FILES.json` for every path/hash and `BUILD-STATUS.json` for current coverage.

The installer downloads pinned original author archives and original GitHub files. We do **not** host third-party mod binaries, bundles, textures, shaders, voices, Fika artwork, SVM, or game/SPT runtime files in this installer. It includes the owner's three installed custom mods plus declarative gameplay settings. Nothing is uploaded by the installer.

## Start

1. Obtain your own working **SPT 4.0.13 / EFT 0.16.9.40087** installation. Use a separate copy, close the game/server/launcher and leave enough room for the staging files and verified backups.
2. Extract this ZIP to a separate folder and double-click **Start-Outlands.cmd**. Windows PowerShell is included with Windows; no compilation or Python installation is required. Windows `tar.exe` supplies 7z support. If it is absent, manually extract original author downloads and supply that folder.
3. Choose **Client** to join the existing server, or **SelfHost** for both client and server mod trees/assets. Supply a folder of legitimately obtained original ZIP/7z downloads or extracted mod files when prompted. Folder layout inside an author archive can differ; imports are accepted only when their file hashes match.
4. Choose **D** to download/import and check files, **I** to install a complete verified set, or **V** to audit existing files. Installation defaults to preview; type `INSTALL` in the launcher only when you want it to apply changes. Profiles and overwritten files are backed up with hash verification before copying. Extra installed mod DLLs cause a refusal; the installer does not delete them.
5. Follow **PLAYING.md** for the privately supplied backend URL and Tailscale settings. No private server address, account, admin key, webhook or Tailscale invite/auth key is distributed.

Downloads and stage files live under `%LOCALAPPDATA%\OutlandsSPT\0.3.0` by default. Reports list missing or mismatched paths. You can resume after obtaining missing originals. Never upload the download cache, assembled stage, profiles or backups: locally acquired author files do not gain redistribution permission.

## Pinned build and configuration

- SPT 4.0.13, commit `2891fd41fd07b6150a2192ac0d24adb93eb72862`; EFT 0.16.9.40087.
- Fika client **2.2.5**; Fika server **author release 2.2.4**. Exact binary comparison resolved a misleading server assembly file version of `2.0.9`. The earlier export reported that assembly metadata; this installer uses the matching author package.
- Binary and asset bytes are checked against the installed snapshot. Original author archive downloads also have SHA-256 pins. A changed archive is rejected; the installer never chooses "latest" automatically.
- Gameplay configuration was converted into declarative INI/JSON facts with semantic equality checks. Comments/formatting may differ from the original snapshot. Private Fika values are empty/loopback and must be configured locally. `CONFIGURATION-PROVENANCE.json` records original and installer hashes. The three already-disabled Revival artifacts are omitted and are not activated. The nested NarcoNet layout and other observed paths are preserved.
- The compact `owner-layer.zip` contains only the owner's custom mod outputs/configuration and generated configuration data. Existing custom source is browsable under the repository's `custom-tools` folder; the older optional research components are not installed.

## Known source gaps

Original CDN links for WTT Armory 2.0.5 and Content Backport 1.0.7 returned 404 during this work. Where the author's original repositories still contain identical files, the installer uses fixed GitHub commits and verifies each output against the installed SHA-256. This is an author source, not a mirror. Later source-repository files are selected only when they match the old installed bytes (with declared UTF-8 line-ending normalization where needed); no later mod DLL is substituted.

Some exact WTT client DLLs, other old builds, and self-host data remain unobtainable through verified current author sources. The matching Better Backpacks author repository/version endpoint is unavailable. The installed Temporary Fixes DLL differs from the currently offered author archive. These gaps require legitimate local imports or refreshed original author sources. This release does **not** call a partial setup ready, reupload those files, or claim a fresh multiplayer test.

## Command line

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\Install-Outlands-Authors.ps1 -Action Plan -Mode Client
powershell -NoProfile -ExecutionPolicy Bypass -File .\Install-Outlands-Authors.ps1 -Action Download -Mode Client -ImportRoot 'D:\OriginalModDownloads'
powershell -NoProfile -ExecutionPolicy Bypass -File .\Install-Outlands-Authors.ps1 -Action Install -Mode Client -SptRoot 'D:\SPT'
powershell -NoProfile -ExecutionPolicy Bypass -File .\Install-Outlands-Authors.ps1 -Action Install -Mode Client -SptRoot 'D:\SPT' -Apply
```

Use `-Mode SelfHost` for the complete client/server set. `-CacheRoot` selects a separate staging/download directory. `-NoDownload` uses only cached or imported files. A single `-SourceId` can be used to troubleshoot one pinned source; it does not waive completeness checks. `-Action Verify` audits mod/config files; network/account changes and later mod-written settings can intentionally differ after first launch.

Source code, factual settings and packaging are MIT where owned by Outlands. Mods downloaded at runtime retain their authors' terms. SAIN-derived preset configuration follows its declared MIT terms with attribution in `THIRD-PARTY-NOTICES.md`. No retail-game rights or blanket mod redistribution permission are granted. This program neither accepts author agreements nor bypasses authentication, CAPTCHA, download permissions, throttles or TLS checks. Author-required interactive downloads must be completed by the user and imported locally.
