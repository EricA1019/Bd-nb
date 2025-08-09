# Testing Strategy (GUT)

- Location: res://scenes/tests/**
  - unit/: pure logic, services
  - integration/: scene wiring, autoload interactions
  - smoke/: boot checks, high-level flows
  - game_flow/: end-to-end slices

- Running
  - VS Code tasks: GUT: All/Fast/Suite/Select/JUnit
  - Makefile: make gut-all, make gut-fast ARGS="-gselect=unit"

- Conventions
  - Tests extend res://addons/gut/test.gd
  - Use assert_no_new_orphans in after_each
  - Prefer get_node_or_null and explicit messages

- Reports (optional)
  - Use JUnit logging with -glog=junit to integrate with CI
