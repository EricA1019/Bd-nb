# Broken Divinity: New Babylon — Roadmap (Close-to-Shore)

Engine: Godot 4.5 beta 3 (GDScript)  •  Renderer: ASCII Grid plugin  •  DB: SQLite (user://bd.db)  •  Saves: JSON (3 slots)
Resolution/Grid: 1280×720 window, 80×36 mono grid  •  Input: Keyboard-first  •  Font: CP437-like base (per-faction fonts deferred)

This roadmap is organized into epochs → phases → hops. Each hop is a tiny, runnable vertical slice with tests and a bootable game. Every 5th hop is a Housekeeping Hop.

References
- Close-to-Shore Bible (Definition of Done, workflow, logging, data-first)
- Preferences (logging tags, UI principles, data-driven conventions)
- docs/WORKFLOW.md (VS Code tasks, Git, CI, logging, data)
- See also: docs/PROJECT_INDEX.md, docs/AGENT_PROMPT.md

Workflow (per hop)
1) Check status, run tests  2) Implementation plan  3) Write failing test(s)  4) Implement until green + bootable  5) Player test  6) Housekeeping (scoped to hop)  7) Docs + index update

Definition of Done (per hop)
- Tests green (unit/integration/smoke/game_flow). Known-failing tests are explicitly tagged/skipped for future hops.
- JSON schema validation passes for data/saves.
- Game boots and demonstrates the hop feature in minimal flow.
- Loud logs with bracketed tags; no silent failures.
- Data discovered (DB/JSON), no hard-coded asset paths (safe fallbacks allowed).
- Docs updated; commit with version tag v0.<phase>.<hop>.

Global technical decisions (locked)
- ASCII: Use addons/Godot-4-ASCII-Grid for exploration and base rendering.
- SQLite: addons/godot-sqlite; DB at user://bd.db; migrations in res://data/sql/ (versioned .sql).
- Content authority: SQLite for static content (suffixes, lore/text, ASCII art, metadata). Saves reference DB rows by stable IDs/GUIDs.
- Saves: user://saves/slot_{1..3}/ with save.json + meta.json (name, playtime, location, screenshot optional later).
- UI Layout: Four panels — TopBar, Center AsciiPanel, Right StatusPanel, Bottom ActionBar. Keyboard-first; mouse later.
- Combat: Turn-based, initiative each round (speed-biased), grid-based (orthogonal adjacency), RNG hit/crit. 2 actions/turn but NOT interchangeable move/attack: at most 1 Move + 1 Act (Fight/Ability/Item/Defend). Damage: physical subtype {ballistic, holy, infernal, fire}. Blessing converts outgoing ballistic→holy for N rounds.
- Reusable Scene + State Machine drives flow: Apartment → Alley → Settlement → Dungeon → End.
- NPC permadeath persists within a save (no globals across saves).
- Logs: user://logs/ for crash/session logs.

Testing & tasks
- Tests under scenes/tests/** separated by type: unit/, integration/, smoke/, game_flow/, scratch/ (scratch removed at the end of a hop).
- VS Code tasks & Makefile mirror: Run Game, GUT: All, GUT: Fast slice.

Hop Template (copy per hop)
- Goal:
- Player-visible demo step:
- Deliverables (checklist)
  - [ ] Tests: unit [ ], integration [ ], smoke [ ], game_flow [ ]
  - [ ] Data: SQL migration(s) [ ] seed data [ ] JSON schema(s) [ ]
  - [ ] Scenes/Nodes: [ ]  • Autoloads: [ ]  • Signals: [ ]
  - [ ] Saves: schema touched? [ ] migration handled [ ] meta.json updated [ ]
  - [ ] Logging: tags added [ ] warnings/errors only when expected [ ]
  - [ ] Manual playtest done [ ]  • Docs updated [ ]  • Tag v0.<p>.<h> [ ]
- Known-failing tests (if any):
- Rollback plan:

Epoch 0 — Foundations & Shell
Phase 0.0 — Project bootstrap and 4-panel shell
Hop 0: Bootstrap, tasks, tests, DB init
- Goal: Bootable 4-panel shell with ASCII grid, autoloads, logging, GUT, SQLite DB created/migrated; 3 save slots directories.
- Deliverables
  - [ ] Autoloads: EventBus, DB, Log, Registries (stubs: AbilityReg, BuffReg, StatusReg)
  - [ ] Scenes: Main.tscn with TopBar, AsciiPanel (80×36), StatusPanel, ActionBar
  - [ ] Logging: Log.gd with bracketed tags; basic startup logs
  - [ ] DB: user://bd.db created; migrations runner; version table; initial schema (res://data/sql/0001_init.sql)
  - [ ] Saves: user://saves/slot_{1..3}/ with meta.json schema
  - [ ] VS Code tasks + Makefile targets; GUT installed & sample tests pass
  - [ ] Smoke test: boots to main shell without errors
- Tests to write
  - [ ] unit: Log formatting; DB migration runner can apply 0001 and set version
  - [ ] integration: Boot Main scene; verify 4 panels exist and ASCII grid size is 80×36
  - [ ] smoke: Title-less boot; no errors in logs

Hop 1: Input loop + camera/grid draw
- Goal: Keyboard input navigates a cursor/actor on the AsciiPanel; redraw loop clean and timed.
- Deliverables
  - [ ] ASCII draw pipeline (room buffer → grid)
  - [ ] Input map (arrow/WASD + confirm/cancel)
  - [ ] Unit tests for buffer ops and bounds

Hop 2: Data discovery + seed content
- Goal: Load some text, ASCII art, and suffix seeds from DB; no hard-coded strings.
- Deliverables
  - [ ] SQL migrations: tables for suffix, lore, ascii_art, factions
  - [ ] Seed rows for demo (imps, angels factions; a handful of suffixes; title ASCII)
  - [ ] Data access layer in DB autoload with typed methods

Hop 3: Save/Load (3 slots) — JSON + meta
- Goal: Save position/state to JSON; meta.json for title screen preview.
- Deliverables
  - [ ] JSON schema(s) for save.json/meta.json
  - [ ] Save/Load services; slot directory mgmt; playtime tracking
  - [ ] Smoke test: create/load slot

Hop 4: Title screen → Continue/New/Load
- Goal: Menu flows to Main; shows 3 slots with metadata.
- Deliverables
  - [ ] Scene: TitleScreen.tscn
  - [ ] Integration tests: create slot, show meta, continue

Hop 5: Housekeeping A
- Goal: Pay down early debt.
  - [ ] Remove scratch tests; prune dead code
  - [ ] Refactor: DB API naming, folder layout, autoload init order
  - [ ] Lint/log review; ensure warnings are intentional
  - [ ] Docs: update PROJECT_INDEX.md, test_baseline.md

Epoch 1 — Core Demo Flow (Apartment → Alley)
Phase 1.0 — Exploration baseline
Hop 6: Apartment scene + static ASCII map
- Goal: Walkable apartment room; mirror hotspot.
- Deliverables
  - [ ] Scene: Apartment.tscn; map from DB ascii_art
  - [ ] Interaction system (hotspots/signs)

Hop 7: Character creation (mirror)
- Goal: Separate scene; choose background (e.g., homicide/narcotics/organized crime) and traits.
- Deliverables
  - [ ] Scene: CharCreate.tscn; returns selections to player profile
  - [ ] Data: backgrounds/traits in DB; IDs stored in save

Hop 8: Inventory + equipment
- Goal: Equip gear; stats modified; tooltips auto-populate.
- Deliverables
  - [ ] UI: Inventory panel; equipment slots
  - [ ] Data: items table; stat mods; affix support stub

Hop 9: Alley escort setup
- Goal: Meet Dona Margarita; short escort path; triggers first encounter.
- Deliverables
  - [ ] Scene: Alley.tscn; static map; NPC follow

Hop 10: Housekeeping B
- Goal: Stabilize before combat.
  - [ ] Scratch tests cleanup; integration tests for flow Apartment→Alley
  - [ ] DB VACUUM/ANALYZE (if applicable); consolidate migrations

Epoch 2 — Combat Beats
Phase 2.0 — First fights and mechanics
Hop 11: Combat framework + initiative
- Goal: Turn system with initiative each round; 2 actions/turn (at most 1 Move + 1 Act).
- Deliverables
  - [ ] BattleManager scene; TurnManager; grid overlay
  - [ ] Unit tests: initiative roll (speed-biased), action flow

Hop 12: Action menus & execution
- Goal: Category menus: Fight, Abilities, Inventory, Defend; input driven.
- Deliverables
  - [ ] ActionBar auto-populates from state
  - [ ] Integration tests: select/resolve actions

Hop 13: Damage types + Blessing buff
- Goal: Physical subtypes: ballistic, holy, infernal, fire. Blessing converts ballistic→holy for N rounds.
- Deliverables
  - [ ] BuffReg, Damage system tables; type conversions
  - [ ] Tests: conversion correctness, duration

Hop 14: First combat scenario — 2 imps with suffixes
- Goal: Scripted battle in alley; imps get semi-random suffixes from DB; showcase weak ballistic then blessed holy.
- Deliverables
  - [ ] Data: enemy templates; suffix system (names/stats modify)
  - [ ] Game flow test: battle outcome per script

Hop 15: Housekeeping C
- Goal: Tighten combat code; remove scaffolding; doc combat APIs.

Epoch 3 — Story Beats & Settlement
Phase 3.0 — Unwinnable angel fight and persistence
Hop 16: Unwinnable angel fight + permadeath
- Goal: Scripted loss; record NPC deaths in save; return to narrative.

Hop 17: Settlement intro (New Babylon)
- Goal: Show basic resource production loop; minimal UI for rates/storage.

Hop 18: Recruit militia + suffixes on recruits
- Goal: Two militia produced; one always has suffix Brave; tutorial callout.

Hop 19: Travel event (angels vs demons) + reward weapon
- Goal: Branching event; recruit side(s) or both with high charm; grant .357 Magnum with affix.

Hop 20: Housekeeping D
- Goal: Stabilize systems before dungeon.

Epoch 4 — Dungeon & Wrap
Phase 4.0 — Procgen and loot
Hop 21: Minimal procgen (rooms + corridors)
- Goal: Simple generator; grid exploration; orthogonal movement; no FOV/LOS.

Hop 22: Loot and gear assignment
- Goal: Drops from tables; assign to self/followers; inventory updated.

Hop 23: Demo wrap
- Goal: Splash/credits; return to title; save completion flag.

Hop 24: Housekeeping E (Pre-release)
- Goal: Remove scratch tests, dead assets; finalize docs; tag demo milestone.

Backlog (post-demo candidates)
- Mouse support; per-faction fonts; FOV/LOS; animations; mod loader (user://mods/); localization pipeline; richer procgen; AI behaviors.

Risks & mitigations
- 4.5 beta API drift: pin plugin versions; smoke tests on upgrade.
- SQLite on non-desktop: keep demo desktop-only; evaluate export templates later.

Versioning & tagging
- Tags: v0.<phase>.<hop> at end of each hop.
- Changelog: append brief entry per tag.

Files to maintain
- ROADMAP.md (this file)
- PROJECT_INDEX.md (components map)
- docs/technical/test_baseline.md (status of tests)
- docs/playtests/<date>_<hop>.md (manual results)

Next actions (Hop 0)
- Create autoload stubs, Main scene shell, DB schema v1, tasks, and baseline tests.
- Confirm CP437-like font asset or fallback; wire ASCII grid to render a room buffer.
