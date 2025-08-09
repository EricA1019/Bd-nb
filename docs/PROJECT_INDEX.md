# Project Index (Broken Divinity: New Babylon)

This is the living index of systems, scenes, data, and tests. Update at the end of every hop.

Status
- Current: Hop 5 (Housekeeping A) — In Progress
- Completed: Hop 4 (Data discovery + seeds + accessors) — v0.0.4; Hop 3 (Save/Load meta + playtime + hotkey + save-on-exit) — v0.0.3; Hop 2 (ASCII grid 80×36 + New Game flow to Main) — v0.0.2; Hop 1 (Title Screen + Save Slots) — v0.0.1; Hop 0 (Bootstrap) — v0.0.0
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
- DB — SQLite connection + migrations + data access (factions, suffixes, lore, ascii_art)
- SaveService — JSON slot management, playtime, Continue/New wiring
- Registries — AbilityReg, BuffReg, StatusReg (stubs)

Core Scenes
- Main.tscn — 4-panel shell (TopBar with slot/playtime label, Ascii center, Right panel, Bottom). Center Ascii uses `scripts/ui/AsciiView.gd`.
- TitleScreen.tscn — Continue/New/Exit. Continue picks latest slot; New initializes slot 1.

Data Model (DB)
- tables: schema_version, factions, suffixes, lore, ascii_art

Testing
- GUT: unit/, integration/, smoke/, game_flow/. Scratch removed at end of hop.
- Current baseline: 19/19 passing; warnings: 0.

Key Tests (added this hop)
- unit/test_db_data_access.gd — schema>=2; factions seeded; ascii art present
- integration/test_data_seed_present.gd — suffixes and intro lore accessible

Log tags
- [AbilityReg] [BuffReg] [StatusReg] [TurnMgr] [CombatMgr] [UI] [Entity]

Versioning
- Tags v0.<phase>.<hop> at hop end. Changelog appended per tag.
