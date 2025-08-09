extends "res://addons/gut/test.gd"

func after_each():
	assert_no_new_orphans()

func test_main_scene_has_four_regions():
	# Load Main scene and instantiate
	var main_scene = load("res://scenes/Main.tscn")
	var main: Node = main_scene.instantiate()
	add_child_autoqfree(main)
	await get_tree().process_frame
	
	# Should have UIRoot with 4 panels
	var ui = main.get_node("UIRoot")
	assert_not_null(ui, "UIRoot exists")
	assert_not_null(ui.get_node_or_null("TopBar"), "TopBar exists")
	assert_not_null(ui.get_node_or_null("BottomBar"), "BottomBar exists") 
	assert_not_null(ui.get_node_or_null("RightPanel"), "RightPanel exists")
	assert_not_null(ui.get_node_or_null("Term"), "Term exists")
