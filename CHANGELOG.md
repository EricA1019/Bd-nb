# Changelog

All notable changes to this project will be documented in this file.

## [v0.0.3] - 2025-08-09
- Hop 3: Save/Load meta (3 slots) via SaveService autoload.
- Playtime tracking in Main; F5 hotkey to save; save-on-exit.
- TitleScreen Continue loads latest slot; New Game initializes slot 1.
- TopBar shows "Slot: X | Playtime mm:ss".
- Tests: unit SaveService; integration save-and-playtime flow. All green.

## [v0.0.2] - 2025-08-09
- Hop 2 complete: ASCII grid 80×36, AsciiView wrapper over TermRect, visible debug UI.
- New Game flow from TitleScreen to Main.
- Tests added for ASCII presence/size and new game flow.

## [v0.0.1] - 2025-08-09
- Hop 1: Title screen and save slots baseline; set TitleScreen as main scene.

## [v0.0.0] - 2025-08-09
- Bootstrap: autoloads (Log, EventBus, DB), DB init/migrations, test scaffolding.
