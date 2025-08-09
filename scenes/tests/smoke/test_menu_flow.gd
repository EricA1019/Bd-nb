extends "res://addons/gut/test.gd"

func test_menu_flow_end_to_end():
	# Boot → TitleScreen → SaveSlotPicker → Main (minimal flow)
	
	# Verify TitleScreen exists and loads
	var title_scene = load("res://scenes/ui/TitleScreen.tscn")
	assert_not_null(title_scene, "TitleScreen should exist")
	
	var title: Node = title_scene.instantiate()
	add_child_autoqfree(title)
	await get_tree().process_frame
	
	# Should have required buttons
	var continue_btn = title.get_node_or_null("UI/ContinueButton")
	var new_game_btn = title.get_node_or_null("UI/NewGameButton") 
	var exit_btn = title.get_node_or_null("UI/ExitButton")
	
	assert_not_null(continue_btn, "Continue button exists")
	assert_not_null(new_game_btn, "New Game button exists") 
	assert_not_null(exit_btn, "Exit button exists")
	
	# For now, just verify buttons exist and scene loads without crashes
	# Full flow testing will come with implementation
