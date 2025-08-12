extends "res://addons/gut/test.gd"

# Hop 8: Apartment exploration tests

func after_each():
	assert_no_new_orphans()

func test_apartment_map_has_rooms_and_interactables():
	var text := DB.read_ascii_art("apartment_map")
	assert_true(text.length() > 0, "apartment_map present")
	assert_true(text.find("#") != -1, "partitions present")
	assert_true(text.find("+") != -1 or text.find("/") != -1, "door tile present")
	for ch in ["B", "N", "C", "M"]:
		assert_true(text.find(ch) != -1, "%s marker present" % ch)

func test_bed_interact_on_e():
	var apt: Node = load("res://scenes/Apartment.tscn").instantiate()
	add_child_autoqfree(apt)
	await get_tree().process_frame
	var fired := [false]
	if apt.has_signal("interacted_with_bed"):
		apt.connect("interacted_with_bed", func(_msg): fired[0] = true)
	if apt.has_method("debug_place_player_at"):
		apt.call("debug_place_player_at", "bed")
	Input.action_press("interact")
	await get_tree().process_frame
	Input.action_release("interact")
	await get_tree().process_frame
	assert_true(fired[0], "bed interaction fired")

func test_kitchen_note_interact_on_e():
	var apt: Node = load("res://scenes/Apartment.tscn").instantiate()
	add_child_autoqfree(apt)
	await get_tree().process_frame
	var fired := [false]
	if apt.has_signal("interacted_with_kitchen_note"):
		apt.connect("interacted_with_kitchen_note", func(_text_id): fired[0] = true)
	if apt.has_method("debug_place_player_at"):
		apt.call("debug_place_player_at", "note")
	Input.action_press("interact")
	await get_tree().process_frame
	Input.action_release("interact")
	await get_tree().process_frame
	assert_true(fired[0], "kitchen note interaction fired")

func test_bathroom_cabinet_interact_on_e():
	var apt: Node = load("res://scenes/Apartment.tscn").instantiate()
	add_child_autoqfree(apt)
	await get_tree().process_frame
	var fired := [false]
	if apt.has_signal("interacted_with_cabinet"):
		apt.connect("interacted_with_cabinet", func(_item): fired[0] = true)
	if apt.has_method("debug_place_player_at"):
		apt.call("debug_place_player_at", "cabinet")
	Input.action_press("interact")
	await get_tree().process_frame
	Input.action_release("interact")
	await get_tree().process_frame
	assert_true(fired[0], "cabinet interaction fired")

func test_can_walk_between_rooms_through_doors():
	var apt: Node = load("res://scenes/Apartment.tscn").instantiate()
	add_child_autoqfree(apt)
	await get_tree().process_frame
	assert_true(apt.has_method("debug_walk_through_any_door"), "debug door helper present")
	var ok: bool = apt.call("debug_walk_through_any_door")
	assert_true(ok, "player can traverse at least one door")

func test_map_has_room_partitions():
	pending("Expand apartment ascii_art map with partitions and doors")
	return

