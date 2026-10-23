# Outlands author installer 0.3.0

- Adds a Windows launcher with Client and SelfHost modes; exact author downloads, cache/resume, ZIP/7z/extracted local imports, hash checks, staging, install preview, verified backups and file audit.
- Downloads all third-party binaries/assets from original author endpoints or requires exact local originals. The release ZIP contains only tools, manifests, owner outputs and declarative settings.
- Pins SPT 4.0.13 / EFT 0.16.9.40087; uses Fika client release 2.2.5 and server release 2.2.4. The installed server's 2.0.9 assembly metadata was misleading: the bytes match the author's 2.2.4 package.
- Regenerates 443 configuration files from sanitized INI/JSON facts, with semantic equality checks. Original and generated hashes are recorded in CONFIGURATION-PROVENANCE.json. Private Fika credentials/addresses remain empty or loopback for local configuration.
- Preserves the snapshot's observed paths and three deployed original mod components. Omits the three already-disabled Revival artifacts. Does not activate earlier experimental projects or relocate the nested NarcoNet deployment.
- Original WTT CDN links are unavailable. Identical files still present in author GitHub repositories are pinned by commit and verified against the snapshot; declared UTF-8 newline/BOM transformations are also checked against final hashes. Some exact old DLL/data files still require local imports.

This documents packaging and observed file changes. It does not establish the origin of undocumented historical tweaks or confirm a fresh remote raid. See the repository's existing docs/CHANGES.md and custom-tools source for earlier documented work.
