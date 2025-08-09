#!/usr/bin/env sh
# Pre-push hook: run headless GUT tests. Block push on failure.
set -eu

echo "[git-hook] Running GUT tests before push..."
GODOT_CMD="${GODOT:-godot}"
"$GODOT_CMD" --headless --path . \
  -s res://addons/gut/gut_cmdln.gd \
  -gdir=res://scenes/tests \
  -ginclude_subdirs \
  -gprefix=test_ \
  -gexit

echo "[git-hook] Tests passed. Proceeding with push."
