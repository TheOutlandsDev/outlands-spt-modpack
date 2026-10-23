# Codex Diagnostics

Passive client diagnostics for the SPT/Fika build.

The BepInEx plugin writes structured JSONL sessions to:

`C:\SPT\Logs\CodexDiagnostics`

It captures:

- session start/end markers
- loaded BepInEx plugin snapshot
- SPT server mod folder snapshot
- Unity warnings/errors/exceptions
- scene loaded events
- FPS, frame-time, hitch, and memory samples
- process CPU, memory, thread, and handle samples
- lightweight in-raid player/bot counts and location context

File writing runs on a background worker with a bounded queue so diagnostics stay useful without adding avoidable frame-time pressure during raids.

Summarize the latest run:

```powershell
powershell -ExecutionPolicy Bypass -File C:\SPT\custom-tools\CodexDiagnostics\Summarize-CodexDiagnostics.ps1
```

Compare the latest run against the previous run:

```powershell
powershell -ExecutionPolicy Bypass -File C:\SPT\custom-tools\CodexDiagnostics\Summarize-CodexDiagnostics.ps1 -ComparePrevious
```


Public package note: installation paths in legacy examples are placeholders. Use the central build/install scripts described in the root README. Headless setup scripts are manual tools; they are not run by the package installer.
