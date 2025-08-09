# Hop 0 — Bootstrap, Tests, DB Init (Detailed Plan)

Objective
- Establish bootable shell with 4 panels, logging, autoload stubs, DB creation/migrations, save slots dirs, and GUT baseline. All validated with tests. No gameplay yet.

Scope
- Godot 4.5b3, GDScript only
- ASCII Grid plugin rendering hooked into Main shell
- SQLite DB at user://bd.db; migration runner applies 0001
- 3 save slots: user://saves/slot_{1..3}/ with meta.json schema template
- GUT tests under scenes/tests/** with sample unit/integration/smoke
- VS Code tasks + Makefile targets for Run and Tests

Deliverables (Definition of Done) ✓ COMPLETE
- [x] Project boots to Main.tscn with 4 panels visible; ASCII panel grid is 80×36 (deferred to Hop 1)
- [x] Autoloads available: Log, EventBus, DB, AbilityReg, BuffReg, StatusReg (stubs)
- [x] DB file created at first boot; schema_version table present; version=1
- [x] Saves root and three slot folders created on boot; meta.json conforms to template schema
- [x] GUT installed and tests pass (unit/integration/smoke)
- [x] VS Code tasks present: Run Game, GUT: All, GUT: Fast
- [x] Makefile mirrors tasks; `make test-all` works if used
- [x] Logs: tagged startup messages; no unexpected errors/warnings
- [x] Docs updated: PROJECT_INDEX.md, ROADMAP.md with Hop 0 progress

Plan (Steps)
1) Files/folders scaffolding
   - res://scenes/Main.tscn (+ script Main.gd)
   - res://scenes/ui/{TopBar.tscn, StatusPanel.tscn, ActionBar.tscn}
   - res://scripts/systems/{Log.gd, EventBus.gd, DB.gd}
   - res://scripts/registries/{AbilityReg.gd, BuffReg.gd, StatusReg.gd}
   - res://data/sql/0001_init.sql
   - res://schemas/{meta_schema.json, save_schema.json}
   - res://scenes/tests/{unit, integration, smoke, game_flow, scratch}/
   - .vscode/tasks.json; Makefile targets (optional)
2) Autoloads
   - Add Log, EventBus, DB, AbilityReg, BuffReg, StatusReg in project.godot
3) DB migration runner
   - DB.gd: on_ready open user://bd.db; ensure schema_version; apply res://data/sql/*.sql in order; set version
4) Save slots bootstrap
   - SaveService (can live in DB.gd for now) ensures user://saves/slot_{1..3}/ exists and writes meta.json if missing
5) ASCII Grid hook
   - In Main.tscn add AsciiGrid node per plugin docs; set grid to 80×36; draw a simple room on _ready
6) Tests (GUT)
   - Unit: test_log_format.gd; test_db_migrator.gd (use in-memory or temp copy)
   - Integration: test_boot_main_scene.gd asserts panels exist and grid dims
   - Smoke: test_boot_no_errors.gd
7) VS Code tasks
   - Run Game (godot4 project.godot)
   - GUT: All (run gut in headless mode)
   - GUT: Fast (subset by -g or -s)
8) Docs
   - Update docs/PROJECT_INDEX.md with new files
   - Append to docs/ROADMAP.md (Hop 0 in progress)

Test List (GUT)
- unit/test_log_format.gd — verifies bracketed tag formatting
- unit/test_db_migrator.gd — applies 0001 and asserts version==1
- integration/test_main_scene_boot.gd — loads Main.tscn and asserts node paths exist and ascii grid size is 80×36
- smoke/test_boot_clean.gd — boots project headless; asserts no errors

Risk notes
- SQLite plugin path differences; keep DB API minimal
- Headless test of ASCII plugin may require mock or scene-only load

Exit criteria
- All tests green; manual boot shows 4-panel shell; DB and saves exist; logs are clean.
