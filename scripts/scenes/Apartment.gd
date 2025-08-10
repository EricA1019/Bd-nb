extends Node

signal interacted_with_mirror

var _grid: Array = []
var _size: Vector2i = Vector2i(80, 36)
var _player_pos: Vector2i = Vector2i(5, 2)
var _mirror_pos: Vector2i = Vector2i(-1, -1)

@onready var ascii := get_node_or_null("Ascii")

func _ready() -> void:
	# Load map from DB
	var text := DB.read_ascii_art("apartment_map")
	if text == "":
		text = _fallback_map()
	_parse_map(text)
	_render()
	set_process_input(true)
	set_process(true)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if _player_pos == _mirror_pos:
			emit_signal("interacted_with_mirror")
			_print_log(["Apartment", "mirror_interact"]) 

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_W, KEY_UP:
				_move(Vector2i(0, -1))
			KEY_S, KEY_DOWN:
				_move(Vector2i(0, 1))
			KEY_A, KEY_LEFT:
				_move(Vector2i(-1, 0))
			KEY_D, KEY_RIGHT:
				_move(Vector2i(1, 0))
	if event is InputEventAction and event.pressed and event.action == "interact":
		if _player_pos == _mirror_pos:
			emit_signal("interacted_with_mirror")
			_print_log(["Apartment", "mirror_interact"]) 

func _move(delta: Vector2i) -> void:
	var np := _player_pos + delta
	if np.x < 0 or np.y < 0 or np.x >= _size.x or np.y >= _size.y:
		return
	if _tile_at(np) == "#":
		return
	_player_pos = np
	_render()

func _tile_at(p: Vector2i) -> String:
	if p.y >= 0 and p.y < _grid.size() and typeof(_grid[p.y]) == TYPE_ARRAY:
		var row: Array = _grid[p.y]
		if p.x >= 0 and p.x < row.size():
			return str(row[p.x])
	return " "

func _render() -> void:
	if ascii == null:
		return
	var buf = ascii.call("create_buffer")
	# draw base
	for y in range(_size.y):
		for x in range(_size.x):
			var ch := _tile_at(Vector2i(x,y))
			var fg := Color(0.85, 0.85, 0.85, 1)
			var bg := Color(0, 0, 0, 1)
			# mirror marker
			if Vector2i(x,y) == _mirror_pos:
				ch = "M"
				fg = Color(1.0, 0.2, 0.8, 1)
			if Vector2i(x,y) == _player_pos:
				ch = "@"
				fg = Color(1, 1, 1, 1)
				bg = Color(0, 0.25, 0, 1)
			buf.put_cell(_make_cell(ch, fg, bg), Vector2i(x,y))
	ascii.call("render_buffer", buf)

func _make_cell(ch: String, fg: Color = Color(1,1,1,1), bg: Color = Color(0,0,0,1)):
	var TermCell = preload("res://addons/Godot-4-ASCII-Grid/addons/ascii_grid/term_cell.gd")
	var c = TermCell.new(ch, fg, bg)
	return c

func _parse_map(text:String) -> void:
	_grid.clear()
	var lines := text.split("\n", false)
	# derive size from longest line up to 80x36
	var h := mini(lines.size(), _size.y)
	var w := 0
	for i in range(h):
		w = maxi(w, lines[i].length())
	w = mini(w, _size.x)
	_size = Vector2i(w, h)
	_mirror_pos = Vector2i(-1,-1)
	for y in range(h):
		var row: Array = []
		for x in range(w):
			var ch := " "
			if x < lines[y].length():
				ch = lines[y][x]
			if ch == "@":
				_player_pos = Vector2i(x,y)
				ch = "."
			if ch == "M":
				_mirror_pos = Vector2i(x,y)
				ch = "."
			row.append(ch)
		_grid.append(row)

func _fallback_map() -> String:
	return "################################################################################\n#...............M...............................................................#\n#................................................................................#\n#....@...........................................................................#\n#................................................................................#\n################################################################################"

func _print_log(parts:Array) -> void:
	var msg := ""
	for p in parts:
		msg += str(p) + " "
	print(msg.strip_edges())
