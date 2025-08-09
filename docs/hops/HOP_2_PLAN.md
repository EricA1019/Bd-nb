# Hop 2 — ASCII Grid Integration (80×36)

Objective
- Replace the placeholder `UIRoot/Term` with the ASCII Grid plugin node and render a simple frame + title at 80×36. No input yet.

Scope
- Godot 4.5b3, GDScript.
- Use `addons/Godot-4-ASCII-Grid`.
- Keep existing four-panel shell (TopBar, RightPanel, BottomBar); center becomes the ASCII view.

Deliverables (Definition of Done)
- [ ] `Main.tscn` contains `UIRoot/Ascii` (plugin node) sized to 80 cols × 36 rows in the available center region.
- [ ] On boot, a border frame is drawn around the usable area and a centered title string is rendered.
- [ ] Tests: unit/integration/smoke green; no unexpected errors/warnings.
- [ ] Logs: clear boot logs for ASCII setup (e.g., `[Ascii] init 80x36`).
- [ ] Docs updated (PROJECT_INDEX.md, ROADMAP.md) with ASCII node and tests.

Plan (Steps)
1) Tests first (failing):
   - `res://scenes/tests/integration/test_ascii_grid.gd` verifies:
     - `UIRoot/Ascii` exists and reports 80×36.
     - A few known glyphs/texts are present (e.g., frame corners, title substring).
   - `res://scenes/tests/smoke/test_ascii_boot.gd` ensures clean boot with ASCII present.
   - (Optional) `unit/test_ascii_draw.gd` for drawing helper pure logic (string centering, clamped coords).
2) Implement scene wiring:
   - Swap `UIRoot/Term` ColorRect → ASCII Grid node (name: `Ascii`).
   - Adjust anchors/offsets so center area matches planned dimensions.
3) Implement draw logic:
   - Add `scripts/ui/AsciiView.gd` attached to the `Ascii` node or to `Main.gd` to:
     - Configure cols=80, rows=36.
     - Draw border (box-drawing or ASCII chars) and a centered title (e.g., "NEW BABYLON").
4) Iterate until tests are green in headless.
5) Docs: update PROJECT_INDEX.md (ASCII node), ROADMAP.md (progress), commit with tag upon approval.

Tests (GUT)
- integration/test_ascii_grid.gd
  - Arrange: instantiate `Main.tscn`.
  - Assert: `UIRoot/Ascii` exists; `get_columns()==80`, `get_rows()==36` (adapt to plugin API); selected tiles/glyphs contain expected border char and title substring.
- smoke/test_ascii_boot.gd
  - Boot and assert no errors; ASCII node exists and is initialized.
- unit/test_ascii_draw.gd (optional)
  - Centering helper returns expected start column for different string lengths.

Risks
- Plugin API naming may differ (`AsciiGrid`, `AsciiTerminal`, methods like `set_size`, `cols/rows`). Validate and adapt tests/impl.
- Headless rendering: assert data/state (grid dimensions and glyph map), not pixels.
- Layout: ensure panel offsets leave enough space for 80×36 given 1280×720; otherwise letterbox or scale logically.

Exit criteria
- All new tests pass; manual boot shows 4 panels with an 80×36 ASCII area framed with a title; clean logs.

Notes
- Input handling and camera/movement are out-of-scope; schedule for a later hop.
- Frame charset: start with plain ASCII (+-|"); switch to box-drawing later if plugin/font supports it.
