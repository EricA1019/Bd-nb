extends "res://addons/gut/test.gd"

func after_each():
	assert_no_new_orphans()

func test_suffixes_and_lore_available():
	var suffixes := DB.get_suffixes()
	assert_true(suffixes.size() >= 2, "suffix seeds present")
	var intro := DB.get_lore("intro")
	assert_true(intro.length() > 0, "intro lore text present")
