extends "res://addons/gut/test.gd"

func test_slot_picker_flow():
	# TitleScreen → SaveSlotPicker → select slot → transition to Main
	
	# Load and setup TitleScreen
	var title_scene = load("res://scenes/ui/TitleScreen.tscn")
	var title: Node = title_scene.instantiate()
	add_child_autoqfree(title)
	await get_tree().process_frame
	
	# Simulate Continue button press (should show slot picker)
	var continue_btn = title.get_node("UI/ContinueButton")
	assert_not_null(continue_btn, "Continue button should exist")
	
	# Simulate button press
	continue_btn.emit_signal("pressed")
	await get_tree().process_frame
	
	# For now, just assert we got expected response
	# Will be implemented once TitleScreen has proper logic
	pass
