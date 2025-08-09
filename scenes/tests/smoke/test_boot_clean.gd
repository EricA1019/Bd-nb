extends "res://addons/gut/test.gd"

func after_each():
	assert_no_new_orphans()

func test_boot_minimal_clean():
	# Autoloads should exist
	assert_not_null(get_node_or_null("/root/Log"), "Log autoload missing")
	assert_not_null(get_node_or_null("/root/EventBus"), "EventBus autoload missing")
	assert_not_null(get_node_or_null("/root/DB"), "DB autoload missing")

	# Let autoloads finish _ready
	await get_tree().process_frame

	# DB version should be >= 1 (after res://data/sql/0001_init.sql)
	var db := get_node("/root/DB")
	var ver: int = db.get_schema_version()
	assert_true(ver >= 1, "schema version should be >= 1, was %s" % [ver])

	# Save slots meta.json should exist (1..3)
	for i in range(1, 4):
		var meta_path := "user://saves/slot_%s/meta.json" % [i]
		assert_true(FileAccess.file_exists(meta_path), "Missing %s" % [meta_path])

	# Main scene should load without error and have the 4 regions
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	add_child_autoqfree(main)
	await get_tree().process_frame
	var ui = main.get_node("UIRoot")
	for c in ui.get_children():
		print("[TEST] UIRoot child:", c.name)
	assert_not_null(ui, "UIRoot exists")
	assert_not_null(ui.get_node_or_null("TopBar"), "TopBar exists")
	assert_not_null(ui.get_node_or_null("BottomBar"), "BottomBar exists")
	assert_not_null(ui.get_node_or_null("RightPanel"), "RightPanel exists")
	assert_not_null(ui.get_node_or_null("Term"), "Term exists")
