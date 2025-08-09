# Godot Testing Best Practices (GUT + Godot 4)

References
- GUT ReadTheDocs (v9.x+)
- bitwes/Gut GitHub
- Community writeups

Conventions
- Use GUT 9.x for Godot 4.
- Place tests under scenes/tests/** with unit/, integration/, smoke/, game_flow/, scratch/
- Name tests `test_*.gd` and suites by feature/system
- Test public API; avoid accessing internals/private members
- Keep tests independent and deterministic
- Use `assert_no_new_orphans()` in `after_each()` for leak hygiene
- When instantiating scenes, call `await get_tree().process_frame` after adding to tree before asserting
- Use headless runs for CI (Godot --headless with GUT)

Headless run example
```sh
# Linux
./godot --headless --path . -s res://addons/gut/gut_cmdln.gd -gdir=res://scenes/tests -ginclude_subdirs -gprefix="test_" -gexit
```

Templated command options
- -gdir: root dir for tests
- -ginclude_subdirs: recurse
- -gprefix: test file prefix filter
- -gexit: quit after run
- -glog: output JUnit or text

Patterns
- Arrange/Act/Assert structure
- Use helper factories to build nodes/resources under test
- Prefer signals for integration assertions
- Mock external deps by injecting simple fakes

Pitfalls
- Timing: rely on `await get_tree().process_frame` instead of fixed timers
- Singletons state bleed: reset or use fresh scene trees if needed
- Plugin nodes in headless: isolate to scene-only loads if rendering not available
