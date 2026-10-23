# The Outlands SPT 0.4.0 — SPT 4.0.13

- Removes all required manual mod imports. Client reconstructs 592 files; SelfHost reconstructs 2,857 files, including the retained assets and Outlands gameplay settings.
- Adds pinned verified archived originals with separate original-author/archive attribution. Recovers BetterBackpacks and old WTT Backport assets/data. Temporary Fixes now uses the matching author 4.0.0 download.
- Builds four unavailable WTT DLLs locally from pinned author source with a portable Microsoft SDK and pinned offline NuGet packages. New reproducible output hashes are declared beside original snapshot hashes. Armory matches 35 client/91 server canonical methods; Backport matches 45 client methods and 78 server raw methods, with the final method structurally matching after proven compiler-temporary normalization. Armory client's SPT reflection reference changes from 4.0.11 to the installed 4.0.13. No source logic or DLL bytes are patched. Source checkout uses recorded Windows CRLF/BOM normalization.
- Adds exact-hash WTT text reconstruction recipes and generates BotCallsigns' combined names from verified downloaded lists.
- Adds private connection preview/apply with verified launcher backups and a webapp shortcut. Public downloads contain no server addresses or credentials. Private companion packages stay local/private.
- Uses The Outlands SPT branding, preserves three deployed Outlands components, and retains the original observed directory layout. The already-disabled Revival artifacts remain omitted. No earlier optional experiments are activated.
- Pins SPT 4.0.13 / EFT 0.16.9.40087, Fika client author release 2.2.5 and Fika server author release 2.2.4 (server assembly file version 2.0.9).

This records packaging, reproducible builds and documented configuration changes. It does not invent undocumented historical tweaks or establish a fresh shared raid. Existing custom source and earlier changes remain in custom-tools and docs/CHANGES.md.
