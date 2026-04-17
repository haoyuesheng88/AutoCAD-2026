[CmdletBinding()]
param(
    [string]$DestinationRoot = $(if ($env:CODEX_HOME) { Join-Path $env:CODEX_HOME "skills" } else { Join-Path $HOME ".codex\\skills" })
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceSkill = Join-Path $repoRoot "skills\\autocad-mechanical-2026"
$destinationSkill = Join-Path $DestinationRoot "autocad-mechanical-2026"

if (-not (Test-Path $sourceSkill)) {
    throw "Skill source folder not found: $sourceSkill"
}

New-Item -ItemType Directory -Path $DestinationRoot -Force | Out-Null

if (Test-Path $destinationSkill) {
    Remove-Item -LiteralPath $destinationSkill -Recurse -Force
}

Copy-Item -LiteralPath $sourceSkill -Destination $destinationSkill -Recurse -Force

Write-Output ("Installed skill to " + $destinationSkill)
