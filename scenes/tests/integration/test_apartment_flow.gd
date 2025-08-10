extends "res://addons/gut/test.gd"

func after_each():
	assert_no_new_orphans()

func test_new_game_transitions_to_apartment():
	var title: Node = load("res://scenes/ui/TitleScreen.tscn").instantiate()
	add_child_autoqfree(title)
	await get_tree().process_frame
	# Press New Game
	title.get_node("UI/NewGameButton").emit_signal("pressed")
	await get_tree().process_frame
	# Should be in Apartment scene
	var current := get_tree().current_scene
	assert_not_null(current)
	assert_eq(current.name, "Apartment")

func test_apartment_boots_and_renders_map():
	var apt: Node = load("res://scenes/Apartment.tscn").instantiate()
	add_child_autoqfree(apt)
	await get_tree().process_frame
	var ascii = apt.get_node("Ascii")
	assert_not_null(ascii, "Ascii exists")
	var buf = ascii.call("create_buffer")
	assert_not_null(buf, "buffer created")
	var rect: Rect2i = buf.get_draw_region()
	assert_true(rect.size.x > 0 and rect.size.y > 0, "grid has size")

func test_mirror_interact_on_e():
	var apt: Node = load("res://scenes/Apartment.tscn").instantiate()
	add_child_autoqfree(apt)
	await get_tree().process_frame
	var flag := [false]
	apt.connect("interacted_with_mirror", func(): flag[0] = true)
	# Move player to mirror by simulating direct state for simplicity
	apt.set("_player_pos", apt.get("_mirror_pos"))
	await get_tree().process_frame
	# Press interact (E)
	Input.action_press("interact")
	await get_tree().process_frame
	Input.action_release("interact")
	await get_tree().process_frame
	assert_true(flag[0], "mirror interaction fired")
