# Broken Divinity: New Babylon — Roadmap (Close-to-Shore)

Engine: Godot 4.5 beta 3 (GDScript)  •  Renderer: ASCII Grid plugin  •  DB: SQLite (user://bd.db)  •  Saves: JSON (3 slots)
Resolution/Grid: 1280×720 window, 80×36 mono grid  •  Input: Keyboard-first  •  Font: CP437-like base (per-faction fonts deferred)

This roadmap is organized into epochs → phases → hops. Each hop is a tiny, runnable vertical slice with tests and a bootable game. Every 5th hop is a Housekeeping Hop.

References
- Close-to-Shore Bible (Definition of Done, workflow, logging, data-first)
- Preferences (logging tags, UI principles, data-driven conventions)
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
Hop 0: Bootstrap, tasks, tests, DB init — Done (v0.0.0)

Hop 1: Title screen + save slots — Done (v0.0.1)
- TitleScreen scene (Continue/New/Exit) wired to Main
- Save slots dir structure and repo; Continue enabled when any meta.json exists
- Tests: menu flow, repo, migrations

Hop 2: ASCII grid 80×36 + New Game flow — Done (v0.0.2)
- Center Ascii panel present in Main; 80×36 grid using AsciiView wrapper
- AsciiView wraps plugin TermRect; TermRootMinimal provides visible border
- Distinct debug colors for panels; Ascii transparent
- New Game transitions from TitleScreen to Main
- Tests added: ascii grid presence/size, New Game flow; smoke tests pass

Hop 3: Save/Load (3 slots) — JSON + meta — Done (v0.0.3)
- Goal: Save position/state to JSON; meta.json for title screen preview.
- Deliverables
  - [x] JSON schema(s) for save.json/meta.json
  - [x] Save/Load services; slot directory mgmt; playtime tracking
  - [x] Smoke test: create/load slot; F5 save; save-on-exit; Continue latest

Hop 4: Data discovery + seed content — Done (v0.0.4)
- Goal: Load some text, ASCII art, and suffix seeds from DB; no hard-coded strings.
- Deliverables
  - [x] SQL migrations: tables for suffix, lore, ascii_art, factions
  - [x] Seed rows for demo (imps, angels factions; a handful of suffixes; title ASCII)
  - [x] Data access layer in DB autoload with typed methods; safe fallbacks
  - [x] Tests: seeds/data access (unit + integration) green

Hop 5: Housekeeping A — Planned
- Goal: Pay down early debt.
  - [ ] Remove scratch tests; prune dead code
  - [ ] Refactor: DB API naming, folder layout, autoload init order
  - [ ] Lint/log review; ensure warnings are intentional
  - [ ] Docs: update PROJECT_INDEX.md, test_baseline.md

Epoch 1 — Core Demo Flow (Apartment → Alley)
Phase 1.0 — Exploration baseline
Hop 6: Apartment scene + static ASCII map — Planned
- Goal: Walkable apartment room; mirror hotspot.
- Deliverables
  - [ ] Scene: Apartment.tscn; map from DB ascii_art
  - [ ] Interaction system (hotspots/signs)

Hop 7: Character creation (mirror) — Planned
- Goal: Separate scene; choose background and traits.

Hop 8: Inventory + equipment — Planned

Hop 9: Alley escort setup — Planned

Hop 10: Housekeeping B — Planned

Backlog (post-demo candidates)
- Mouse support; per-faction fonts; FOV/LOS; animations; mod loader; localization; richer procgen; AI behaviors.

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
