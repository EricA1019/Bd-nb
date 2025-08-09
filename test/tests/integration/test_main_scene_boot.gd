extends "res://addons/gut/test.gd"

func after_each():
	assert_no_new_orphans()

func test_main_scene_has_four_regions():
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	add_child_autoqfree(main)
	await get_tree().process_frame
	var ui = main.get_node("UIRoot")
	assert_true(ui != null, "UIRoot exists")
	assert_true(ui.get_node("TopBar") != null, "TopBar exists")
	assert_true(ui.get_node("BottomBar") != null, "BottomBar exists")
	assert_true(ui.get_node("RightPanel") != null, "RightPanel exists")
	assert_true(ui.get_node("Term") != null, "Term exists")
