extends Control

func _ready() -> void:
	print("[Main] boot")

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
#EOF
