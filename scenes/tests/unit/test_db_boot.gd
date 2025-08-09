extends "res://addons/gut/test.gd"

func after_each():
	assert_no_new_orphans()

func test_db_migrates_and_saves_ready():
	# Let DB autoload finish initialization
	await get_tree().process_frame
	
	# DB should have schema version >= 1 after migration
	var db := get_node("/root/DB")
	var version: int = db.get_schema_version()
	assert_true(version >= 1, "schema version should be >= 1, was %s" % [version])
	
	# Save slots meta.json should exist for slots 1-3
	for i in range(1, 4):
		var meta_path := "user://saves/slot_%s/meta.json" % [i]
		assert_true(FileAccess.file_exists(meta_path), "Missing %s" % [meta_path])
