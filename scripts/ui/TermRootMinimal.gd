extends Node

var _rect: Rect2i = Rect2i()
var _dirty: bool = true

func is_redraw_required() -> bool:
	return _dirty

func set_rect(rect: Rect2i) -> void:
	_rect = rect
	_dirty = true

func update_sizing() -> void:
	# No-op for minimal root
	_dirty = true

func blit_to_buffer(buffer) -> void:
	# Draw a simple border using faux cells
	var white = Color(1,1,1,1)
	var black = Color(0,0,0,1)
	var Cell = preload("res://addons/Godot-4-ASCII-Grid/addons/ascii_grid/term_cell.gd")
	# top/bottom
	for x in _rect.size.x:
		buffer._grid[Vector2i(x, 0)] = Cell.new("-", white, black)
		buffer._grid[Vector2i(x, _rect.size.y-1)] = Cell.new("-", white, black)
	# sides
	for y in _rect.size.y:
		buffer._grid[Vector2i(0, y)] = Cell.new("|", white, black)
		buffer._grid[Vector2i(_rect.size.x-1, y)] = Cell.new("|", white, black)
	# corners
	buffer._grid[Vector2i(0,0)] = Cell.new("+", white, black)
	buffer._grid[Vector2i(_rect.size.x-1,0)] = Cell.new("+", white, black)
	buffer._grid[Vector2i(0,_rect.size.y-1)] = Cell.new("+", white, black)
	buffer._grid[Vector2i(_rect.size.x-1,_rect.size.y-1)] = Cell.new("+", white, black)
	_dirty = false
