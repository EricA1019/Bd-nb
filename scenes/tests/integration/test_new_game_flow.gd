extends "res://addons/gut/test.gd"

func after_each():
	assert_no_new_orphans()

func test_new_game_transitions_to_main():
	var title: Node = load("res://scenes/ui/TitleScreen.tscn").instantiate()
	add_child_autoqfree(title)
	await get_tree().process_frame
	# Press New Game
	title.get_node("UI/NewGameButton").emit_signal("pressed")
	await get_tree().process_frame
	# Should be in Apartment scene for Hop 6
	var tree := get_tree()
	var current := tree.current_scene
	assert_not_null(current, "Current scene is set")
	assert_eq(current.name, "Apartment", "Transitions to Apartment scene")
