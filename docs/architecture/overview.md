# Architecture Overview

Flow
- Boot to `scenes/ui/TitleScreen.tscn` → New Game → `scenes/Main.tscn`.

Rendering
- `AsciiView` extends ColorRect and wraps plugin `TermRect`.
- `TermRootMinimal` provides a minimal render tree; draws a border for visibility.
- Shader `term_shader.gdshader` blends fg/bg based on glyph texture.

Autoloads
- `Log.gd`, `EventBus.gd`, `DB.gd` initialized at startup.

Data
- SQLite DB at user://bd.db; versioned migrations in res://data/sql.
