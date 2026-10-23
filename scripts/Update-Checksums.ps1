param([string]$PackageRoot = (Split-Path -Parent $PSScriptRoot))
$ErrorActionPreference = 'Stop'
$root = [IO.Path]::GetFullPath($PackageRoot)
$entries = @(); $sourceEntries = @()
Get-ChildItem -LiteralPath $root -Recurse -File -Force | ForEach-Object {
    $relative = [IO.Path]::GetRelativePath($root, $_.FullName).Replace('\','/')
    if ($relative -in 'SHA256SUMS','SOURCE-SHA256SUMS' -or $relative -match '(^|/)(\.git|\.build|bin|obj)/') { return }
    $hash = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
    $entry = "$hash  $relative"
    $entries += $entry
    if ($_.Extension -notin '.dll','.bundle','.png','.jpg','.jpeg','.webp') { $sourceEntries += $entry }
}
$entries | Sort-Object | Set-Content -LiteralPath (Join-Path $root 'SHA256SUMS') -Encoding utf8
$sourceEntries | Sort-Object | Set-Content -LiteralPath (Join-Path $root 'SOURCE-SHA256SUMS') -Encoding utf8
Write-Host "Recorded $($entries.Count) package file hashes."
