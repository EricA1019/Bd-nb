extends "res://addons/gut/test.gd"

func after_each():
	assert_no_new_orphans()

func test_db_migrates_to_v2_and_has_seeds():
	assert_true(DB.get_schema_version() >= 2, "schema version >= 2")
	var factions := DB.get_factions()
	assert_true(factions.size() >= 2, "has at least 2 factions")
	var keys := []
	for f in factions:
		keys.append(f.get("key", ""))
	assert_true(keys.has("imps") and keys.has("angels"), "includes imps and angels")
	assert_ne(DB.get_ascii_art("title"), "", "title ascii present")
