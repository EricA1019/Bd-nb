extends "res://addons/gut/test.gd"

func after_each():
	assert_no_new_orphans()

func test_ascii_node_exists_and_is_80x36():
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	add_child_autoqfree(main)
	await get_tree().process_frame
	var ui = main.get_node("UIRoot")
	var ascii = ui.find_child("Ascii", true, false)
	assert_not_null(ascii, "UIRoot/Ascii exists")
	# Query buffer size via create_buffer() and draw region
	var buf = ascii.call("create_buffer")
	assert_not_null(buf, "Ascii.create_buffer returns buffer")
	var grid_rect: Rect2i = buf.get_draw_region()
	assert_eq(grid_rect.size, Vector2i(80, 36), "Grid should be 80x36")
	# term_root should be configured
	var term_root = ascii.get("term_root")
	assert_not_null(term_root, "Ascii.term_root configured")
	# Explicitly free to avoid GUT 'unfreed children' warning in after_each
	main.queue_free()
	await get_tree().process_frame
