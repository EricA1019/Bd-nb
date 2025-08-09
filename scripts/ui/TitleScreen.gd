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

func _update_continue_button() -> void:
	# Enable Continue if any save slot has meta.json
	var has_saves := false
	for i in range(1, 4):
		var meta_path := "user://saves/slot_%s/meta.json" % [i]
		if FileAccess.file_exists(meta_path):
			has_saves = true
			break
	
	continue_btn.disabled = not has_saves

func _on_continue_pressed() -> void:
	print("[TitleScreen] Continue pressed")
	# For now, just transition to Main
	# Later: show SaveSlotPicker or go to most recent slot
	_transition_to_main()

func _on_new_game_pressed() -> void:
	print("[TitleScreen] New Game pressed") 
	# For now, just transition to Main
	# Later: show SaveSlotPicker for slot selection
	_transition_to_main()

func _on_exit_pressed() -> void:
	print("[TitleScreen] Exit pressed")
	get_tree().quit()

func _transition_to_main() -> void:
	print("[TitleScreen] Transitioning to Main")
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
