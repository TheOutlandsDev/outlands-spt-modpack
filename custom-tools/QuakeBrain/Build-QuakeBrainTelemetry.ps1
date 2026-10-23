param([Parameter(Mandatory=$true)][string]$SptRoot)
$ErrorActionPreference = 'Stop'
$packageRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
& (Join-Path $packageRoot 'scripts/Build-Outlands.ps1') -SptRoot $SptRoot -Project 'QuakeBrain'
