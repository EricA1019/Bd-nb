# Broken Divinity: New Babylon

**Hop 0 Complete** ✓ — Bootstrap: Autoloads, 4-panel shell, DB init, save slots

## Hop 1 Plan: Title Screen + Save Slots

Goal
- Create main menu scene with Continue/New Game/Exit options
- Implement save slot picker UI with 3 slots showing meta.json info
- Wire navigation: Main → TitleScreen → slot selection → Main (stub)

Player-visible demo step
1. Launch game → shows TitleScreen instead of Main
2. Select "Continue" → shows 3 save slots with names/timestamps from meta.json 
3. Select slot or "New Game" → returns to Main scene (transition stub)
4. Can exit cleanly via "Exit" button

Deliverables (checklist)
- [ ] Tests: unit [TitleScreen logic], integration [scene transitions], smoke [boot to title], game_flow [full menu flow]
- [ ] Data: SQL migration(s) [none], seed data [none], JSON schema(s) [save slot meta schema]
- [ ] Scenes/Nodes: [TitleScreen.tscn, SaveSlotPicker.tscn] • Autoloads: [none new] • Signals: [EventBus.title_*, slot_*]
- [ ] Manual playtest done [ ] • Docs updated [ ] • Tag v0.0.1 [ ]

Tests to write (test-first)
- scenes/tests/unit/test_title_screen.gd: TitleScreen button logic, slot meta loading
- scenes/tests/integration/test_scene_navigation.gd: Main ↔ TitleScreen transitions
- scenes/tests/smoke/test_boot_to_title.gd: game boots to TitleScreen, not Main
- scenes/tests/game_flow/test_menu_flow.gd: Continue→SlotPicker→selection→Main roundtrip

Implementation plan
1. Create failing tests defining TitleScreen behavior
2. Create TitleScreen.tscn with Continue/New/Exit buttons 
3. Create SaveSlotPicker.tscn with 3 slot buttons showing meta.json data
4. Wire EventBus signals for navigation
5. Update project.godot main_scene to TitleScreen
6. Implement scene management/transitions in Main or new SceneManager

Known-failing tests (if any)
- test_main_scene_boot.gd may need updates once TitleScreen becomes main scene

Rollback plan
- Revert project.godot main_scene to Main.tscn
- Keep TitleScreen scenes as optional/unused until working

Next actions after lockdown
- Write failing tests for TitleScreen
- Create TitleScreen.tscn scene with buttons
- Implement navigation flow via EventBus
