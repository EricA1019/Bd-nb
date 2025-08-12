extends Node

signal interacted_with_mirror
signal interacted_with_bed(msg)
signal interacted_with_kitchen_note(text_id)
signal interacted_with_cabinet(item)
# New interactable signals
signal interacted_with_fridge(text)
signal interacted_with_closet(item)
signal interacted_with_drawer(item)
signal interacted_with_shower(text)
signal interacted_with_kitchen_cabinet(item)

var _grid: Array = []
var _size: Vector2i = Vector2i(80, 36)
var _player_pos: Vector2i = Vector2i(5, 2)
var _mirror_pos: Vector2i = Vector2i(-1, -1)
var _bed_pos: Vector2i = Vector2i(-1, -1)
var _cabinet_pos: Vector2i = Vector2i(-1, -1)
var _note_pos: Vector2i = Vector2i(-1, -1)
# New interactable positions
var _fridge_pos: Vector2i = Vector2i(-1, -1)
var _closet_pos: Vector2i = Vector2i(-1, -1)
var _drawer_pos: Vector2i = Vector2i(-1, -1)
var _shower_pos: Vector2i = Vector2i(-1, -1)
var _kitchen_cabinet_pos: Vector2i = Vector2i(-1, -1)

var ascii: Node = null
var _right_label: Label = null
var _bottom_label: Label = null

func _ready() -> void:
	# resolve ascii view anywhere in the scene tree
	ascii = find_child("Ascii", true, false) as Node
	# Load map from DB
	var text := DB.read_ascii_art("apartment_map")
	if text == "":
		text = _fallback_map()
	_parse_map(text)
	_render()
	# Create UI labels if panels exist in this scene
	var rp := get_node_or_null("RightPanel")
	if rp:
		_right_label = rp.get_node_or_null("RightText")
		if _right_label == null:
			_right_label = Label.new()
			_right_label.name = "RightText"
			_right_label.autowrap_mode = TextServer.AUTOWRAP_WORD
			_right_label.offset_left = 8
			_right_label.offset_top = 8
			_right_label.offset_right = 300
			_right_label.offset_bottom = 700
			rp.add_child(_right_label)
	var bb := get_node_or_null("BottomBar")
	if bb:
		_bottom_label = bb.get_node_or_null("BottomText")
		if _bottom_label == null:
			_bottom_label = Label.new()
			_bottom_label.name = "BottomText"
			_bottom_label.autowrap_mode = TextServer.AUTOWRAP_WORD
			_bottom_label.offset_left = 8
			_bottom_label.offset_top = 8
			_bottom_label.offset_right = 1264
			_bottom_label.offset_bottom = 72
			bb.add_child(_bottom_label)
	# Subscribe to EventBus for UI text
	var eb := get_node_or_null("/root/EventBus")
	if eb:
		eb.event.connect(_on_event)
	set_process_input(true)
	set_process(true)

func _on_event(tag:String, payload:Variant) -> void:
	if tag == "ui.right_text" and _right_label:
		_right_label.text = str(payload)
	elif (tag == "ui.bottom_text" or tag == "ui.bottom_choices") and _bottom_label:
		_bottom_label.text = str(payload)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		_try_interact()

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
		_try_interact()

func _try_interact() -> void:
	# Toggle door if standing on one
	var here := _tile_at(_player_pos)
	if here == "+":
		_set_tile(_player_pos, "/")
		_render()
		_print_log(["Apartment", "door_open"]) 
		_emit_choice_text("Door opens. [E] to close.")
		return
	elif here == "/":
		_set_tile(_player_pos, "+")
		_render()
		_print_log(["Apartment", "door_close"]) 
		_emit_choice_text("Door closes. [E] to open.")
		return
	# Mirror
	if _player_pos == _mirror_pos:
		emit_signal("interacted_with_mirror")
		_print_log(["Apartment", "mirror_interact"]) 
		_emit_ui_text(DB.read_lore("mirror") if DB.has_method("read_lore") else "You see yourself.")
		_emit_choice_text("[E] Step away")
		return
	# Bed
	if _player_pos == _bed_pos:
		emit_signal("interacted_with_bed", "You feel rested.")
		_print_log(["Apartment", "bed_interact"]) 
		_emit_ui_text("The sheets are a mess. Maybe later.")
		_emit_choice_text("[E] Make bed • [WASD] Move")
		return
	# Note
	if _player_pos == _note_pos:
		emit_signal("interacted_with_kitchen_note", "kitchen_note_1")
		_print_log(["Apartment", "note_interact"]) 
		_emit_ui_text(DB.read_lore("kitchen_note_1") if DB.has_method("read_lore") else "A hastily scribbled recipe.")
		_emit_choice_text("[E] Put back • [WASD] Move")
		return
	# Cabinet (bathroom)
	if _player_pos == _cabinet_pos:
		emit_signal("interacted_with_cabinet", "cabinet_item_1")
		_print_log(["Apartment", "cabinet_interact"]) 
		_emit_ui_text("Empty toothpaste boxes and bandages.")
		_emit_choice_text("[E] Close cabinet")
		return
	# Fridge
	if _player_pos == _fridge_pos:
		var t1 := DB.read_lore("fridge_text") if DB.has_method("read_lore") else "The fridge hums."
		emit_signal("interacted_with_fridge", t1)
		_print_log(["Apartment", "fridge_interact"]) 
		_emit_ui_text(t1)
		_emit_choice_text("[E] Close fridge • [WASD] Move")
		return
	# Drawer (nightstand)
	if _player_pos == _drawer_pos:
		emit_signal("interacted_with_drawer", "model10_38")
		_print_log(["Apartment", "drawer_interact", "model10_38"]) 
		var t2 := DB.read_lore("drawer_model10") if DB.has_method("read_lore") else "There's a revolver in here."
		_emit_ui_text(t2)
		_emit_choice_text("[E] Take • [WASD] Move")
		return
	# Closet
	if _player_pos == _closet_pos:
		emit_signal("interacted_with_closet", "old_leather_jacket")
		_print_log(["Apartment", "closet_interact", "old_leather_jacket"]) 
		var t3 := DB.read_lore("closet_jacket") if DB.has_method("read_lore") else "Your old jacket is here."
		_emit_ui_text(t3)
		_emit_choice_text("[E] Wear • [WASD] Move")
		return
	# Shower
	if _player_pos == _shower_pos:
		var t4 := DB.read_lore("shower_flavor") if DB.has_method("read_lore") else "The shower sputters cold water."
		emit_signal("interacted_with_shower", t4)
		_print_log(["Apartment", "shower_interact"]) 
		_emit_ui_text(t4)
		_emit_choice_text("[E] Turn off • [WASD] Move")
		return
	# Kitchen cabinet (whiskey)
	if _player_pos == _kitchen_cabinet_pos:
		emit_signal("interacted_with_kitchen_cabinet", "kitchen_whiskey")
		_print_log(["Apartment", "kitchen_cabinet_interact", "kitchen_whiskey"]) 
		var t5 := DB.read_lore("kitchen_whiskey") if DB.has_method("read_lore") else "A bottle of whiskey."
		_emit_ui_text(t5)
		_emit_choice_text("[E] Take • [WASD] Move")
		return

func _move(delta: Vector2i) -> void:
	var np := _player_pos + delta
	if np.x < 0 or np.y < 0 or np.x >= _size.x or np.y >= _size.y:
		return
	var tch := _tile_at(np)
	if tch == "#":
		return
	_player_pos = np
	_render()

func _tile_at(p: Vector2i) -> String:
	if p.y >= 0 and p.y < _grid.size() and typeof(_grid[p.y]) == TYPE_ARRAY:
		var row: Array = _grid[p.y]
		if p.x >= 0 and p.x < row.size():
			return str(row[p.x])
	return " "

func _set_tile(p: Vector2i, ch: String) -> void:
	if p.y >= 0 and p.y < _grid.size() and typeof(_grid[p.y]) == TYPE_ARRAY:
		var row: Array = _grid[p.y]
		if p.x >= 0 and p.x < row.size():
			row[p.x] = ch

func _render() -> void:
	if ascii == null:
		return
	var buf = ascii.call("create_buffer")
	# draw base
	for y in range(_size.y):
		for x in range(_size.x):
			var pos := Vector2i(x, y)
			var ch := _tile_at(pos)
			var fg := Color(0.85, 0.85, 0.85, 1)
			var bg := Color(0, 0, 0, 1)
			# colorize tiles
			if ch == "#":
				# Draw walls as solid black blocks to avoid glyph mapping issues
				ch = "█"
				fg = Color.BLACK
				bg = Color.BLACK
			elif ch == ".":
				fg = Color.SADDLE_BROWN
			elif ch == "+":
				fg = Color(0.9, 0.75, 0.3, 1)
			elif ch == "/":
				fg = Color(1.0, 0.95, 0.6, 1)
			# mirror marker overlay
			if pos == _mirror_pos:
				ch = "M"
				fg = Color(1.0, 0.2, 0.8, 1)
			# interactable overlays (DF/CP437 pictographs where applicable)
			if pos == _bed_pos:
				ch = "Θ" # bed
				fg = Color(0.85, 0.6, 0.95, 1)
			elif pos == _cabinet_pos:
				ch = "π" # bathroom cabinet
				fg = Color(0.95, 0.85, 0.45, 1)
			elif pos == _note_pos:
				ch = "N"
				fg = Color(0.6, 0.9, 1.0, 1)
			elif pos == _fridge_pos:
				ch = "F"
				fg = Color(0.6, 0.8, 1.0, 1)
			elif pos == _drawer_pos:
				ch = "D"
				fg = Color(1.0, 0.85, 0.6, 1)
			elif pos == _closet_pos:
				ch = "L"
				fg = Color(0.8, 0.7, 0.5, 1)
			elif pos == _shower_pos:
				ch = "S"
				fg = Color(0.6, 1.0, 1.0, 1)
			elif pos == _kitchen_cabinet_pos:
				ch = "K"
				fg = Color(0.9, 0.8, 0.6, 1)
			# player overlay (last)
			if pos == _player_pos:
				ch = "@"
				fg = Color(1, 1, 1, 1)
				bg = Color(0, 0.25, 0, 1)
			buf.put_cell(_make_cell(ch, fg, bg), pos)
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
	_bed_pos = Vector2i(-1,-1)
	_cabinet_pos = Vector2i(-1,-1)
	_note_pos = Vector2i(-1,-1)
	_fridge_pos = Vector2i(-1,-1)
	_closet_pos = Vector2i(-1,-1)
	_drawer_pos = Vector2i(-1,-1)
	_shower_pos = Vector2i(-1,-1)
	_kitchen_cabinet_pos = Vector2i(-1,-1)
	for y in range(h):
		var row: Array = []
		for x in range(w):
			var ch := " "
			if x < lines[y].length():
				ch = lines[y][x]
			if ch == "@":
				_player_pos = Vector2i(x,y)
				ch = "."
			elif ch == "M":
				_mirror_pos = Vector2i(x,y)
				ch = "."
			elif ch == "B":
				_bed_pos = Vector2i(x,y)
				ch = "."
			elif ch == "C":
				_cabinet_pos = Vector2i(x,y)
				ch = "."
			elif ch == "N":
				_note_pos = Vector2i(x,y)
				ch = "."
			elif ch == "F":
				_fridge_pos = Vector2i(x,y)
				ch = "."
			elif ch == "L":
				_closet_pos = Vector2i(x,y)
				ch = "."
			elif ch == "D":
				_drawer_pos = Vector2i(x,y)
				ch = "."
			elif ch == "S":
				_shower_pos = Vector2i(x,y)
				ch = "."
			elif ch == "K":
				_kitchen_cabinet_pos = Vector2i(x,y)
				ch = "."
			# retain door tiles '+' or '/' as-is
			row.append(ch)
		_grid.append(row)

func _fallback_map() -> String:
	return "################################################################################\n#...............M...............................................................#\n#................................................................................#\n#....@...........................................................................#\n#................................................................................#\n################################################################################"

func _print_log(parts:Array) -> void:
	var msg := ""
	for p in parts:
		msg += str(p) + " "
	print(msg.strip_edges())

# Debug helper for tests
func debug_place_player_at(what: String) -> void:
	match what:
		"bed":
			if _bed_pos.x != -1:
				_player_pos = _bed_pos
		"note":
			if _note_pos.x != -1:
				_player_pos = _note_pos
		"cabinet":
			if _cabinet_pos.x != -1:
				_player_pos = _cabinet_pos
		"mirror":
			if _mirror_pos.x != -1:
				_player_pos = _mirror_pos
	_render()

func debug_step(delta: Vector2i) -> void:
	_move(delta)

func debug_walk_through_any_door() -> bool:
	# Find a door with two opposite walkable tiles and try to cross it.
	for y in range(_size.y):
		for x in range(_size.x):
			var p: Vector2i = Vector2i(x,y)
			var ch: String = _tile_at(p)
			if ch == "+" or ch == "/":
				var pairs: Array = [
					[Vector2i(-1,0), Vector2i(1,0)],
					[Vector2i(0,-1), Vector2i(0,1)]
				]
				for pair in pairs:
					var a: Vector2i = p + pair[0]
					var b: Vector2i = p + pair[1]
					if _in_bounds(a) and _in_bounds(b):
						var ca: String = _tile_at(a)
						var cb: String = _tile_at(b)
						if ca != "#" and cb != "#":
							_player_pos = a
							_render()
							var d: Vector2i = b - a
							_move(d)
							return _player_pos == b
	return false

func _in_bounds(p: Vector2i) -> bool:
	return p.x >= 0 and p.y >= 0 and p.x < _size.x and p.y < _size.y

# Emit UI text to RightPanel via EventBus autoload if available
func _emit_ui_text(text: String) -> void:
	var eb := get_node_or_null("/root/EventBus")
	if eb and eb.has_method("emit_event"):
		eb.call("emit_event", "ui.right_text", text)

func _emit_choice_text(text: String) -> void:
	var eb := get_node_or_null("/root/EventBus")
	if eb and eb.has_method("emit_event"):
		eb.call("emit_event", "ui.bottom_text", text)
