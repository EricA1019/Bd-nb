# Project Index (Broken Divinity: New Babylon)

This is the living index of systems, scenes, data, and tests. Update at the end of every hop.

Status
- Current: Hop 3 — TBD (next small vertical slice)
- Completed: Hop 2 (ASCII grid 80×36 + New Game flow to Main) — v0.0.2; Hop 1 (Title Screen + Save Slots) — v0.0.1; Hop 0 (Bootstrap) — v0.0.0
- Engine: Godot 4.5 beta 3 (GDScript)
- Rendering: ASCII Grid plugin (+ wrapper `AsciiView` with hidden `TermRect` and `TermRootMinimal`)
- DB: SQLite (user://bd.db) with migrations in res://data/sql/
- Saves: JSON (3 slots) in user://saves/slot_{1..3}/

Directory map
- Scenes: res://scenes/
- Scripts: res://scripts/
- Data (DB seeds/sql): res://data/
- Schemas: res://schemas/
- Tests: res://scenes/tests/
- Docs: res://docs/ (Workflow, Testing, CI)

Autoloads
- Log — bracketed tag logger
- EventBus — signal hub
- DB — SQLite connection + migrations
- Registries — AbilityReg, BuffReg, StatusReg (stubs)

Core Scenes
- Main.tscn — 4-panel shell (TopBar, AsciiPanel, StatusPanel, ActionBar). Center Ascii uses `scripts/ui/AsciiView.gd` which wraps the plugin `TermRect` and a minimal `TermRootMinimal` for testable rendering.
- TitleScreen.tscn — slot picker entry (Continue/New/Exit). New Game transitions to `Main.tscn`.

Data Model (DB)
- tables: schema_version, factions, suffixes, lore, ascii_art, items, enemies, buffs, abilities

Tests layout
- scenes/tests/unit/
- scenes/tests/integration/
- scenes/tests/smoke/
- scenes/tests/game_flow/
- scenes/tests/scratch/ (purged at end of hop)

Key Tests (added this hop)
- integration/test_ascii_grid.gd — Ascii node exists and buffer is 80×36
- integration/test_new_game_flow.gd — New Game transitions to Main
- smoke/test_ascii_boot.gd — Ascii boots clean

Log tags
- [AbilityReg] [BuffReg] [StatusReg] [TurnMgr] [CombatMgr] [UI] [Entity]

Open decisions
- CP437-like font asset selection (fallback ok for early hops).

Versioning
- Tags v0.<phase>.<hop> at hop end. Changelog appended per tag.
