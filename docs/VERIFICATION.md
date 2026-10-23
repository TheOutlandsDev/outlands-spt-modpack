# Verification for 0.1.0-dev.1

Checked on 2026-10-23. This report records static/build and disposable-fixture results. It does not claim gameplay readiness.

| Check | Result |
| --- | --- |
| privacy and file allowlist | PASS |
| source builds | PASS |
| third party binary identity | PASS |
| checksum generation | PASS |
| package checksums | PASS |
| installer preview no writes | PASS |
| installer fixture copy backup preserve | PASS |
| installed file receipt | PASS |
| checksum rejects tampering | PASS |
| checksum rejects missing files | PASS |
| checksum rejects path escape | PASS |
| powershell parse | PASS |
| final package checksums | PASS |
| source only checksums | PASS |
| checksum rejects unlisted payload | PASS |
| final preview no writes | PASS |
| final installer backup profile preservation | PASS |
| final installed hashes | PASS |
| explicit config replacement | PASS |
| rejects incompatible eft target | PASS |
| fika configuration sanitized | PASS |
| final privacy scan | PASS |

Nine original projects compiled successfully with zero warnings/errors using .NET SDK 9.0.310, the installed .NET Framework targeting references and the pinned local SPT/game assemblies. The .NET Framework client builds needed installed Windows SDK registration access outside the restricted execution sandbox; this did not install or launch software.

Fixture checks copied the SPT server executable only to read its file-version metadata; they did not execute it. Installer testing covered preview without writes, installed hashes, verified backups of overwritten files/profiles, preserving configs by default, explicit config replacement and incompatible EFT rejection. The fixture and original personal data were not placed in the public package.

All 15 included third-party DLL files matched their inspected installed originals byte-for-byte. This is not a comparison with upstream release archives. License notices were preserved; text line endings were normalized to LF.

The privacy scan checked for known local profile identifiers, original network addresses/paths/credential values, credential patterns, forbidden file categories and excluded game assemblies. It found no matches in the prepared export. This is a targeted audit, not a universal guarantee that all possible sensitive strings can be recognized.

SPT core runtime/game assets are external prerequisites. The inventory explicitly records unresolved third-party permissions and missing full-build reproduction coverage.

**Not performed:** SPT/game startup, gameplay raids, save round trips with experimental components, two-PC multiplayer, headless runtime, compatibility of all external mods or performance benchmarking. See [TEST-PLAN.md](TEST-PLAN.md).

Machine-readable check details are in `manifests/verification.json`. `SHA256SUMS` covers the complete release asset; `SOURCE-SHA256SUMS` covers the text source checkout. Both hash files exclude themselves and each other to avoid a cyclic checksum dependency.
