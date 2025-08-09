extends "res://addons/gut/test.gd"

func test_project_boots_to_title_screen():
	# After Hop 1, project.godot main_scene should point to TitleScreen
	# For now, this will fail until we change main_scene
	var main_scene_path: String = ProjectSettings.get_setting("application/run/main_scene")
	# KNOWN FAILING - will pass after TitleScreen implementation
	assert_eq(main_scene_path, "res://scenes/ui/TitleScreen.tscn", 
		"Main scene should be TitleScreen, not Main")

func test_title_screen_loads_without_error():
	# TitleScreen scene should instantiate cleanly
	var title_scene = load("res://scenes/ui/TitleScreen.tscn")
	assert_not_null(title_scene, "TitleScreen.tscn should exist")
	
	var title_instance: Node = title_scene.instantiate()
	add_child_autoqfree(title_instance)
	await get_tree().process_frame
	
	# Should have expected UI elements
	assert_not_null(title_instance.get_node_or_null("UI/ContinueButton"), "Continue button exists")
	assert_not_null(title_instance.get_node_or_null("UI/NewGameButton"), "New Game button exists")
	assert_not_null(title_instance.get_node_or_null("UI/ExitButton"), "Exit button exists")
