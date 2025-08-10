extends Control

@onready var _ascii := get_node_or_null("UIRoot/Ascii")

func _ready() -> void:
	print("[Main] boot")
	# Minimal placeholder draw using the proper glyph atlas
	call_deferred("_render_placeholder")

func _process(delta: float) -> void:
	var svc := get_node_or_null("/root/SaveService")
	if svc:
		svc.call("add_session_seconds", delta)
		# update top bar label
		var lbl := get_node_or_null("UIRoot/TopBar/TopBarLabel")
		if lbl:
			var seconds := int(svc.call("get_display_playtime_seconds"))
			var mm: int = int(float(seconds) / 60.0)
			var ss: int = seconds % 60
			var slot: int = int(svc.call("get_current_slot"))
			var slot_s: String = str(slot) if slot > 0 else "-"
			lbl.text = "Slot: %s | Playtime %02d:%02d" % [slot_s, mm, ss]

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_F5:
		var svc := get_node_or_null("/root/SaveService")
		if svc:
			svc.call("force_save", 0)
		accept_event()

func _exit_tree() -> void:
	var svc := get_node_or_null("/root/SaveService")
	if svc:
		svc.call("force_save", 0)

func _render_placeholder() -> void:
	if _ascii == null:
		return
	var buf = _ascii.call("create_buffer")
	# Keep it mostly empty so Apartment becomes the primary renderer
	_ascii.call("render_buffer", buf)

func _put_text(buf, pos: Vector2i, text: String, fg: Color, bg: Color) -> void:
	for i in text.length():
		buf.put_cell(_cell(text[i], fg, bg), Vector2i(pos.x + i, pos.y))

func _cell(ch: String, fg: Color, bg: Color):
	var TermCell = preload("res://addons/Godot-4-ASCII-Grid/addons/ascii_grid/term_cell.gd")
	return TermCell.new(ch, fg, bg)
#EOF
