extends ColorRect

@export var tile_size: Vector2i = Vector2i(8, 16)
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
	_term_rect.characters_per_line = 16
	_term_rect.term_root = term_root
	_term_rect.automatic_redraw = true
	_term_rect.visible = true
	# Provide a tiny placeholder font texture to avoid null shader param
	var img := Image.create(1, 1, false, Image.FORMAT_RGBA8)
	img.set_pixel(0, 0, Color.WHITE)
	var tex := ImageTexture.create_from_image(img)
	_term_rect.font = tex
	add_child(_term_rect)

func _get_grid_size() -> Vector2i:
	var px := Vector2(size)
	return Vector2i(floor(px.x / float(tile_size.x)), floor(px.y / float(tile_size.y)))

func create_buffer():
	# Compute from our own rect to avoid timing/layout issues
	var grid := _get_grid_size()
	# Prefer plugin TermBuffer so downstream code matches expectations
	var TB = preload("res://addons/Godot-4-ASCII-Grid/addons/ascii_grid/term_buffer.gd")
	return TB.new(grid)

func render() -> void:
	if is_instance_valid(_term_rect):
		_term_rect.render()
	# else no-op
