# AutoCAD-2026

This repository stores a reusable Codex skill for attaching to an already open `AutoCAD Mechanical 2026` desktop instance and drawing a square through COM automation.

## Included

- `skills/autocad-mechanical-2026/`
  The skill itself, including `SKILL.md`, UI metadata, and the PowerShell automation script.
- `install-skill.ps1`
  Copies the skill into the local Codex skills directory on another Windows computer.

## Use On Another Computer

1. Clone this repository.
2. Open PowerShell in the repository root.
3. Run:

```powershell
.\install-skill.ps1
```

By default, the script installs into `$HOME\.codex\skills\autocad-mechanical-2026`.

## Direct Script Usage

With AutoCAD Mechanical 2026 already open:

```powershell
& ".\skills\autocad-mechanical-2026\scripts\draw-square-in-open-autocad.ps1"
```
