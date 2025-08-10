extends Control

@onready var continue_btn := $UI/ContinueButton
@onready var new_game_btn := $UI/NewGameButton
@onready var exit_btn := $UI/ExitButton

func _ready() -> void:
	print("[TitleScreen] boot")
	
	# Wire button signals
	continue_btn.pressed.connect(_on_continue_pressed)
	new_game_btn.pressed.connect(_on_new_game_pressed)
	exit_btn.pressed.connect(_on_exit_pressed)
	
	# Check save slot availability
	_update_continue_button()

func _svc() -> Node:
	return get_node_or_null("/root/SaveService")

func _update_continue_button() -> void:
	# Enable Continue if any save slot has meta.json
	var has_saves := false
	var svc := _svc()
	if svc:
		has_saves = int(svc.call("get_latest_slot")) > 0
	else:
		for i in range(1, 4):
			var meta_path := "user://saves/slot_%s/meta.json" % [i]
			if FileAccess.file_exists(meta_path):
				has_saves = true
				break
	
	continue_btn.disabled = not has_saves

func _on_continue_pressed() -> void:
	print("[TitleScreen] Continue pressed")
	var svc := _svc()
	if svc:
		var s := int(svc.call("get_latest_slot"))
		if s > 0:
			svc.call("set_current_slot", s)
			_transition_to_main()
		else:
			print("[TitleScreen] No saves found")
	else:
		_transition_to_main()

func _on_new_game_pressed() -> void:
	print("[TitleScreen] New Game pressed") 
	var svc := _svc()
	if svc:
		svc.call("set_current_slot", 1)
		svc.call("start_session")
		svc.call("force_save", 0)
	# Transition to Apartment for Hop 6
	get_tree().change_scene_to_file("res://scenes/Apartment.tscn")

func _on_exit_pressed() -> void:
	print("[TitleScreen] Exit pressed")
	get_tree().quit()

func _transition_to_main() -> void:
	print("[TitleScreen] Transitioning to Main")
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
