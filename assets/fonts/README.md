Place CP437-compatible font atlases here for the ASCII renderer.

Required atlas for this project:
- Filename: cp437_16x16.png
- Grid: 16 columns × 16 rows (256 glyphs total)
- Tile size: 16×16 px
- Image size: 256×256 px
- Mapping: Code Page 437 order (indices 0–255), left-to-right, top-to-bottom

Godot import settings (important for crisp pixels):
- Filter: Off
- Mipmaps: Off
- Repeat: Disabled
- Compression: Lossless/Default

Detection:
- `AsciiView` auto-loads `res://assets/fonts/cp437_16x16.png` when present.
- Fallback: In headless/CI or when atlas is missing, a generated placeholder is used (solid blocks).

To add a real tileset:
1) Drop a CC0/compatible CP437 PNG here as `cp437_16x16.png` and include its license file.
2) Run the game; the ASCII panel should render crisp glyphs.

Generating a placeholder atlas:
- You can run the generator at `res://scripts/dev/gen_placeholder_atlas.gd` (headless-safe) to create a 256×256 placeholder `cp437_16x16.png` with a visible grid. Replace it later with a real CP437 tileset.
