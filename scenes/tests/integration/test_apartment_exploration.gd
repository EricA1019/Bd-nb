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
	pending("Implement Apartment bed interaction (signal: interacted_with_bed)")
	return
	# Example flow (to be enabled when implemented):
	# var apt: Node = load("res://scenes/Apartment.tscn").instantiate()
	# add_child_autoqfree(apt)
	# await get_tree().process_frame
	# var fired := [false]
	# if apt.has_signal("interacted_with_bed"):
	# 	apt.connect("interacted_with_bed", func(): fired[0] = true)
	# # Place player at bed and interact (implementation should provide positioning or parse from map)
	# if apt.has_method("debug_place_player_at"):
	# 	apt.call("debug_place_player_at", "bed")
	# Input.action_press("interact")
	# await get_tree().process_frame
	# Input.action_release("interact")
	# await get_tree().process_frame
	# assert_true(fired[0], "bed interaction fired")

func test_kitchen_note_interact_on_e():
	pending("Implement Apartment kitchen note interaction (signal: interacted_with_kitchen_note)")
	return
	# See test_bed_interact_on_e for example flow

func test_bathroom_cabinet_interact_on_e():
	pending("Implement Apartment bathroom cabinet interaction (signal: interacted_with_cabinet)")
	return
	# See test_bed_interact_on_e for example flow

func test_can_walk_between_rooms_through_doors():
	pending("Implement door tiles and transitions between bedroom/kitchen/bathroom zones")
	return
	# Example flow:
	# var apt: Node = load("res://scenes/Apartment.tscn").instantiate()
	# add_child_autoqfree(apt)
	# await get_tree().process_frame
	# if apt.has_method("debug_place_player_at"):
	# 	apt.call("debug_place_player_at", "bedroom")
	# # Simulate movement towards a door tile 'D' and into next room
	# for i in 10:
	# 	Input.parse_input_event(InputEventKey.new()) # placeholder for movement helpers
	# await get_tree().process_frame
	# assert_true(true)

func test_map_has_room_partitions():
	pending("Expand apartment ascii_art map with partitions and doors")
	return

