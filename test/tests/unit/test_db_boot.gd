extends "res://addons/gut/test.gd"

func after_each():
	assert_no_new_orphans()

func test_db_migrates_and_saves_ready():
	# DB is an autoload
	var db := get_node_or_null("/root/DB")
	assert_not_null(db, "DB autoload should exist")
	await get_tree().process_frame
	# Schema version should be >= 1 after 0001_init.sql
	var ver:int = db.get_schema_version()
	assert_true(ver >= 1, "schema version should be >= 1, was %s" % [ver])
	# Save slots 1..3 meta.json should exist
	for i in range(1, 4):
		var meta_path:String = "user://saves/slot_%s/meta.json" % [i]
		assert_true(FileAccess.file_exists(meta_path), "Missing %s" % [meta_path])
