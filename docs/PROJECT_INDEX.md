# Project Index (Broken Divinity: New Babylon)

This is the living index of systems, scenes, data, and tests. Update at the end of every hop.

Status
- Current: Hop 2 — PLANNED (TBD)
- Completed: Hop 1 (Title Screen + Save Slots) — v0.0.1; Hop 0 (Bootstrap) — v0.0.0
- Engine: Godot 4.5 beta 3 (GDScript)
- Rendering: ASCII Grid plugin
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
- Main.tscn — 4-panel shell (TopBar, AsciiPanel, StatusPanel, ActionBar)
- TitleScreen.tscn — slot picker entry (Continue/New/Exit)

Data Model (DB)
- tables: schema_version, factions, suffixes, lore, ascii_art, items, enemies, buffs, abilities

Tests layout
- scenes/tests/unit/
- scenes/tests/integration/
- scenes/tests/smoke/
- scenes/tests/game_flow/
- scenes/tests/scratch/ (purged at end of hop)

Log tags
- [AbilityReg] [BuffReg] [StatusReg] [TurnMgr] [CombatMgr] [UI] [Entity]

Open decisions
- CP437-like font asset selection (fallback ok for early hops).

Versioning
- Tags v0.<phase>.<hop> at hop end. Changelog appended per tag.
