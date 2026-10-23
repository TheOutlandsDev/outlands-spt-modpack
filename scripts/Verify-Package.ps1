param([string]$PackageRoot = (Split-Path -Parent $PSScriptRoot), [switch]$SourceOnly)
$ErrorActionPreference = 'Stop'
$root = [IO.Path]::GetFullPath($PackageRoot).TrimEnd('\')
$manifestName = if ($SourceOnly) { 'SOURCE-SHA256SUMS' } else { 'SHA256SUMS' }
$manifestPath = Join-Path $root $manifestName
if (-not (Test-Path -LiteralPath $manifestPath)) { throw "$manifestName is missing." }
$count = 0
$known = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($line in Get-Content -LiteralPath $manifestPath) {
    if (-not $line.Trim()) { continue }
    if ($line -notmatch '^([a-f0-9]{64})  (.+)$') { throw 'Invalid checksum entry.' }
    $expected = $Matches[1]; $relative = $Matches[2]
    if (-not $known.Add($relative.Replace('\','/'))) { throw 'Duplicate checksum entry.' }
    $target = [IO.Path]::GetFullPath((Join-Path $root $relative))
    if (-not $target.StartsWith($root + '\', [StringComparison]::OrdinalIgnoreCase)) { throw 'Unsafe checksum path.' }
    if (-not (Test-Path -LiteralPath $target -PathType Leaf)) { throw "Missing package file: $relative" }
    $actual = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($actual -ne $expected) { throw "Checksum mismatch: $relative" }
    $count++
}
if (-not $SourceOnly -and (Test-Path -LiteralPath (Join-Path $root 'payload'))) {
    foreach ($file in Get-ChildItem -LiteralPath (Join-Path $root 'payload') -Recurse -File -Force) {
        $relative = [IO.Path]::GetRelativePath($root, $file.FullName).Replace('\','/')
        if (-not $known.Contains($relative)) { throw "Unlisted payload file: $relative" }
    }
}
Write-Host "Verified $count package files."
