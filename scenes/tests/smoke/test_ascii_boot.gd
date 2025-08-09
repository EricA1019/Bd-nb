extends "res://addons/gut/test.gd"

func after_each():
	assert_no_new_orphans()

func test_ascii_boots_clean():
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	add_child_autoqfree(main)
	await get_tree().process_frame
	var ascii = main.get_node("UIRoot").find_child("Ascii", true, false)
	assert_not_null(ascii, "Ascii node exists")
	# render should not error even if no children
	pass
