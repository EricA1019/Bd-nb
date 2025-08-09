# Scenes/Tests Template - GUT
# Usage: copy to scenes/tests/<suite>/test_<feature>.gd and fill in
extends "res://addons/gut/test.gd"

var AutoFree = load("res://addons/gut/autofree.gd")

func before_all():
	# Setup shared resources
	pass

func after_all():
	# Cleanup
	pass

func before_each():
	gut.p("[Test] before_each")

func after_each():
	assert_no_new_orphans()

func test_example_unit():
	# Arrange
	var value = 1
	# Act
	var result = value + 1
	# Assert
	assert_eq(result, 2, "Sanity check")
