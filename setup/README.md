# Outlands SPT Modpack 0.2.0 — setup kit

**This is a setup/inventory kit, not a complete playable modpack download.** The original installation is reported working by its owner. Its complete sanitized installed mod trees were captured locally; redistribution of the full set is not cleared. The previous 0.1.0 ZIP is also a curated subset.

Target: **SPT 4.0.13 / EFT 0.16.9.40087 / Fika client 2.2.5.0 / Fika server 2.0.9**. See `build.json` for the SPT commit.

`setup-lock.json` lists every exported client/server mod, asset and config with size and SHA-256. `mod-downloads.json` records observed versions, included files, licenses and author-download/provenance gaps. `Outlands-Setup.ps1` audits file parity, assembles exact local author downloads, and installs only a complete payload with verified backups. `PLAYING.md` separates joining over Tailscale from self-hosting.

Some locally customized settings are not publicly bundled yet. Obtaining a default author download may therefore leave missing config hashes. Do not advertise this kit as reproducing the full setup until every required file can be obtained and real multiplayer tests pass.

Only the cleared subset is under `payload`. No game files, base SPT runtime, saves, account state, certificates, API keys, private server address or Tailscale credentials are included. Fika handcrafted artwork is withheld. SVM is external because its license requires redistribution permission; the owner confirmed no additional author permissions. CC NoDerivatives licenses can allow unchanged noncommercial sharing with attribution, but do not establish that an installed copy is unchanged or that all asset rights are covered.

Developer source and documented original changes: https://github.com/TheOutlandsDev/outlands-spt-modpack/tree/v0.1.0-dev.1-spt4.0.13/custom-tools and the repository's `docs/CHANGES.md`. The three installed custom components were captured from the working deployment. Optional research projects are not enabled in this snapshot.

Start with **PLAYING.md** and **PUBLICATION-STATUS.md**. No compilation is required for these file tools.
