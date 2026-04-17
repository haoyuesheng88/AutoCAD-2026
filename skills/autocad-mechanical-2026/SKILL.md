---
name: autocad-mechanical-2026
description: Attach to an already open AutoCAD Mechanical 2026 desktop instance on Windows and draw a square in the active drawing through AutoCAD COM automation. Use when the user says AutoCAD Mechanical 2026 is installed and open locally and wants Codex to connect to that running app, inspect the active document, or create a square at a chosen size and origin without relying on manual command-line typing inside AutoCAD.
---

# AutoCAD Mechanical 2026

Use this skill when AutoCAD Mechanical 2026 is already running on Windows and the task is to attach to the open desktop app and draw a square in the current drawing.

Prefer COM automation over simulated typing inside AutoCAD. It is more reliable, easier to validate, and avoids focus problems.

## Workflow

1. Confirm that an AutoCAD Mechanical window is already open when the user says it is.
2. Run [scripts/draw-square-in-open-autocad.ps1](./scripts/draw-square-in-open-autocad.ps1) instead of rebuilding the COM logic by hand.
3. Unless the user specifies otherwise, draw the square in model space with:
   - side length `100`
   - origin `(0, 0)`
4. Regenerate the drawing and zoom extents after creation so the square is visible.
5. Report the drawing name and the square parameters you used.

## Quick Rules

- Assume Windows PowerShell and desktop AutoCAD Mechanical 2026.
- Attach to the active AutoCAD instance with COM using `Marshal.GetActiveObject`.
- Try `AutoCAD.Application.25.1` first, then fall back to older generic AutoCAD ProgIDs if needed.
- Draw the square as a closed lightweight polyline in model space.
- Do not depend on AutoCAD command-line text entry if the same result can be done through COM.
- If AutoCAD is not already open, stop and say that the application must be launched first.
- If there is no active drawing, create one only if the user explicitly asks; otherwise stop and explain the blocker.

## Script Usage

Default square:

```powershell
& ".\skills\autocad-mechanical-2026\scripts\draw-square-in-open-autocad.ps1"
```

Custom size and origin:

```powershell
& ".\skills\autocad-mechanical-2026\scripts\draw-square-in-open-autocad.ps1" -Size 250 -OriginX 500 -OriginY 300
```

## Output

The script prints a compact JSON object containing:

- `DocumentName`
- `ProgId`
- `Origin`
- `Size`
- `Closed`

Use that output to confirm the operation succeeded.
