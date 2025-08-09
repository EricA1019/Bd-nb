# Test Baseline

How to run
- Headless (all):
  godot --headless --path . -s res://addons/gut/gut_cmdln.gd -gdir=res://scenes/tests -ginclude_subdirs -gprefix=test_ -gexit
- Fast slice:
  godot --headless --path . -s res://addons/gut/gut_cmdln.gd -gdir=res://scenes/tests -ginclude_subdirs -gprefix=test_ -gexit -gselect=unit

Suites
- unit/: DB migrations, sanity
- integration/: Title boot, Main shell, ASCII grid 80×36, New Game flow
- smoke/: boot clean, menu flow

CI
- GitHub Actions executes the same headless command on push/PR.
