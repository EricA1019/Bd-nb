# Changelog

All notable changes to this project will be documented in this file.

## [v0.1.3] - 2025-08-12
- Hop 8.2: Interaction UI — RightPanel narrative and Bottom choices wired for Apartment scene. Added EventBus handlers; emitted ui.right_text and ui.bottom_text from interactions. Taller BottomBar in Main; Apartment scene includes its own Right/Bottom panels when run directly.

## [v0.1.2] - 2025-08-12
- Hop 8: Apartment exploration — base interactions (mirror, bed, note, cabinet) and door toggles. Added more interactables: fridge (F), closet (L), nightstand drawer (D), shower (S), kitchen cabinet (K). Flavor texts seeded; interactions emit UI text to RightPanel via EventBus. Door traversal helper for tests.

## [v0.1.1] - 2025-08-12
- Hop 7: ASCII display MVP finalized. CP437 16×16 atlas validated (256×256). `AsciiView` tightened to prefer user atlas and validate 256 glyphs. Main layout fixed to 80×36 under TopBar. Tests green.

## [v0.0.5] - 2025-08-09
- Hop 5: Housekeeping A.
- Test hygiene: fix float/int compare; free scenes in tests; 0 warnings baseline.
- Demote DB migration noise; add DB API aliases (list_/read_) without breaking.
- Docs: update roadmap, project index; add test_baseline.md.

## [v0.0.4] - 2025-08-09
- Hop 4: Data discovery + seed content.
- Added SQL migration (0002) and idempotent seed ensure in DB autoload.
- Data accessors in DB: get_factions, get_suffixes, get_lore, get_ascii_art (with safe fallbacks).
- Tests added: unit DB data access; integration seed presence. All green.

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
