extends ColorRect

@export var tile_size: Vector2i = Vector2i(16, 16)
var term_root: Node
var _term_rect: Node

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	self.color = Color(0,0,0,0)
	# Ensure a minimal term_root exists for tests
	if term_root == null:
		var TermRootMinimal = preload("res://scripts/ui/TermRootMinimal.gd")
		term_root = TermRootMinimal.new()
		add_child(term_root)
	# Add plugin TermRect as child (hidden). Keep AsciiView as the stable interface.
	var TermRect = preload("res://addons/Godot-4-ASCII-Grid/addons/ascii_grid/term_rect.gd")
	_term_rect = TermRect.new()
	_term_rect.name = "TermRect"
	_term_rect.anchors_preset = PRESET_FULL_RECT
	_term_rect.tile_size = tile_size
	# default to 16 columns
	_term_rect.characters_per_line = 16
	_term_rect.term_root = term_root
	# We'll drive rendering via render_buffer from scenes
	_term_rect.automatic_redraw = false
	_term_rect.visible = true
	# Prefer a real atlas if present; otherwise generate an in-memory one for CI/headless
	var atlas: Texture2D = null
	# Prefer user atlases first (they can be generated at runtime) then res:// fallbacks
	var candidates := [
		# User-generated atlas locations
		"user://assets/fonts/cp437_16x16.png",
		"user://assets/fonts/cp437_8x16.png",
		# Project assets
		"res://assets/fonts/cp437_16x16.png",
		"res://assets/fonts/cp437_8x16.png",
		"res://assets/fonts/terminal_16x16.png",
		"res://assets/fonts/terminal16x16.png",
		"res://assets/fonts/terminal.png",
		"res://assets/fonts/cp437.png",
		"res://addons/Godot-4-ASCII-Grid/examples/UI_Mockup/terminus_8x16.png"
	]
	for p in candidates:
		var tex: Texture2D = null
		if p.begins_with("user://"):
			if FileAccess.file_exists(p):
				var img0 := Image.new()
				if img0.load(p) == OK:
					tex = ImageTexture.create_from_image(img0)
		else:
			if ResourceLoader.exists(p):
				tex = load(p)
		if tex:
			# Validate: ensure this atlas can represent 256 glyphs with sane tile sizes
			var img := tex.get_image()
			if img and img.get_width() > 0 and img.get_height() > 0:
				var w := img.get_width()
				var h := img.get_height()
				var valid := false
				var inferred_size := tile_size
				var inferred_cols := 16
				# Try common tile sizes first
				for combo in [Vector2i(16,16), Vector2i(8,16)]:
					if (w % combo.x == 0) and (h % combo.y == 0):
						var cols := int(w / combo.x)
						var rows := int(h / combo.y)
						if cols * rows == 256:
							inferred_size = combo
							inferred_cols = cols
							valid = true
							break
				# As a backup, try inferring via plausible column counts with constraints
				if not valid:
					for cols2 in [16, 32, 8]:
						if 256 % cols2 != 0:
							continue
						var rows2: int = int(256 / cols2)
						if w % cols2 == 0 and h % rows2 == 0:
							var tw := int(round(float(w) / float(cols2)))
							var th := int(round(float(h) / float(rows2)))
							# Accept only sensible glyph sizes
							if (tw in [8, 12, 16]) and (th in [12, 16]):
								inferred_size = Vector2i(tw, th)
								inferred_cols = cols2
								valid = true
								break
				if valid:
					atlas = tex
					# Apply inferred settings
					_term_rect.tile_size = inferred_size
					_term_rect.characters_per_line = inferred_cols
					tile_size = inferred_size
					break
				# else: try next candidate
	if atlas:
		_term_rect.font = atlas
	else:
		# Fallback: simple placeholder to keep tests running
		var img_fallback := Image.create(256, 256, false, Image.FORMAT_RGBA8)
		img_fallback.fill(Color.WHITE)
		var tex_fallback := ImageTexture.create_from_image(img_fallback)
		_term_rect.font = tex_fallback
		_term_rect.tile_size = Vector2i(16,16)
		_term_rect.characters_per_line = 16
		tile_size = Vector2i(16,16)
	add_child(_term_rect)

func _ensure_ready() -> void:
	if is_instance_valid(_term_rect):
		# Ensure internal images/grid are allocated
		_term_rect.call("_resize")

func _get_grid_size() -> Vector2i:
	var px := Vector2(size)
	return Vector2i(floor(px.x / float(tile_size.x)), floor(px.y / float(tile_size.y)))

func create_buffer():
	_ensure_ready()
	# Compute from our own rect to avoid timing/layout issues
	var grid := _get_grid_size()
	# Prefer plugin TermBuffer so downstream code matches expectations
	var TB = preload("res://addons/Godot-4-ASCII-Grid/addons/ascii_grid/term_buffer.gd")
	return TB.new(grid)

func render() -> void:
	if is_instance_valid(_term_rect):
		_ensure_ready()
		_term_rect.render()
	# else no-op

func render_buffer(buffer) -> void:
	# Allow callers to render their own composed buffer directly.
	if is_instance_valid(_term_rect):
		_ensure_ready()
		_term_rect.render_buffer(buffer)
