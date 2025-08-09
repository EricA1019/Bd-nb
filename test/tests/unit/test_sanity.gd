extends "res://addons/gut/test.gd"

func after_each():
	assert_no_new_orphans()

func test_math_adds():
	assert_eq(1+1, 2)
