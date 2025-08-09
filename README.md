# Broken Divinity: New Babylon

Godot 4.5 (GDScript) project using an ASCII grid renderer, SQLite-backed data, and a tests-first Close-to-Shore workflow.

Quickstart
- Requirements: Godot 4.5 beta 3+, git, Linux/mac/Win.
- Run game: use VS Code task "Godot: Run Game" or: `godot --path .`
- Run tests (headless): `godot --headless --path . -s res://addons/gut/gut_cmdln.gd -gdir=res://scenes/tests -ginclude_subdirs -gprefix=test_ -gexit`

Workflow
- Hops: small vertical slices; tests-first; visible debug UI; loud logs.
- CI: GitHub Actions runs GUT on push/PR.
- Tags: v0.<phase>.<hop> at each hop; see CHANGELOG.md.
- Branches: feature/* → PR → main; release/* for tagged hops.
- Pre-push hook: `make install-hooks` to enable local pre-push tests.

Directories
- Scenes: `res://scenes/`  • Scripts: `res://scripts/`  • Tests: `res://scenes/tests/`
- Docs: `docs/` (ROADMAP, PROJECT_INDEX, WORKFLOW, TESTING)

Notes
- ASCII grid via `AsciiView` wrapper over plugin `TermRect`; minimal `TermRootMinimal` supplies visible border.
- DB: SQLite user://bd.db with versioned migrations in res://data/sql.
