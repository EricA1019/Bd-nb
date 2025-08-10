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
	# CP437 atlas is 16 columns
	_term_rect.characters_per_line = 16
	_term_rect.term_root = term_root
	# We'll drive rendering via render_buffer from scenes
	_term_rect.automatic_redraw = false
	_term_rect.visible = true
	# Prefer a real atlas if present; otherwise generate an in-memory one for CI/headless
	var atlas: Texture2D = null
	var candidates := [
		"res://assets/fonts/cp437_16x16.png",
		"res://assets/fonts/cp437_8x16.png",
		"res://assets/fonts/terminal_16x16.png",
		"res://assets/fonts/terminal16x16.png",
		"res://assets/fonts/terminal.png",
		"res://assets/fonts/cp437.png",
		"res://addons/Godot-4-ASCII-Grid/examples/UI_Mockup/terminus_8x16.png",
		# User-generated atlas locations
		"user://assets/fonts/cp437_16x16.png",
		"user://assets/fonts/cp437_8x16.png"
	]
	var chosen_path := ""
	for p in candidates:
		if p.begins_with("user://"):
			if FileAccess.file_exists(p):
				var img := Image.new()
				if img.load(p) == OK:
					atlas = ImageTexture.create_from_image(img)
					chosen_path = p
					break
		else:
			if ResourceLoader.exists(p):
				atlas = load(p)
				chosen_path = p
				break
	if atlas:
		_term_rect.font = atlas
		# Try to infer tile size from the atlas image or filename
		var inferred := tile_size
		var cols := 16
		var rows := int(256.0 / float(cols))
		var img2: Image = null
		if atlas is Texture2D:
			img2 = (atlas as Texture2D).get_image()
		if img2 and img2.get_width() > 0 and img2.get_height() > 0:
			var tw := int(round(float(img2.get_width()) / float(cols)))
			var th := int(round(float(img2.get_height()) / float(rows)))
			inferred = Vector2i(max(1, tw), max(1, th))
		elif chosen_path.findn("16x16") != -1 or chosen_path.findn("terminal") != -1:
			inferred = Vector2i(16, 16)
		elif chosen_path.findn("8x16") != -1:
			inferred = Vector2i(8, 16)
		# Apply inferred tile size
		_term_rect.tile_size = inferred
		tile_size = inferred
	else:
		var img := Image.create(128, 256, false, Image.FORMAT_RGBA8)
		img.fill(Color.WHITE)
		var tex := ImageTexture.create_from_image(img)
		_term_rect.font = tex
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
