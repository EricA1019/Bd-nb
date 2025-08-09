# Workflow & Tooling (Close-to-Shore)

## Summary
Short hops, tests-first, bootable slices. Every 5th hop is Housekeeping.

## VS Code
- Tasks: Godot Run, GUT All/Fast/Suite/Select/JUnit
- Copilot Chat default agent set at workspace level
- File/search excludes for .godot/.import/docs cache

## Git
- Tag per hop: v0.<phase>.<hop>
- Convert `addons/Godot-4-ASCII-Grid` to a submodule, or remove its inner `.git`.
- .gitignore covers .godot/.import/logs/editor artifacts.

## Testing (GUT)
- All tests under res://scenes/tests/**
- Suites: unit, integration, smoke, game_flow, scratch
- Run headless via VS Code tasks or `make`.

## CI (proposed)
- GitHub Actions: run headless GUT, upload JUnit XML.

## Debugging Godot
- In Godot Editor: Editor → Editor Settings → Network → Debug → Remote Host/Port (127.0.0.1:6007)
- Start game from Godot; attach from VS Code using a compatible extension (e.g., Godot Tools) if needed.

## Logging
- Bracketed tags, no silent failures. Consider enabling file logging later.

## Data
- SQLite migrations under res://data/sql
- JSON schemas under res://schemas

## Next improvements
- Add JUnit artifacts task, CI workflow, .editorconfig, debugger attach.
