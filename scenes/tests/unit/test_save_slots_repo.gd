extends "res://addons/gut/test.gd"

func test_load_save_slot_meta():
	# Should gracefully handle missing meta.json files
	for i in range(1, 4):
		var meta_path := "user://saves/slot_%s/meta.json" % [i]
		var meta = _load_slot_meta(i)
		
		if FileAccess.file_exists(meta_path):
			assert_not_null(meta, "Meta should load for existing slot %s" % [i])
			assert_true(meta.has("name"), "Meta should have name field")
			assert_true(meta.has("created"), "Meta should have created field")
		else:
			assert_null(meta, "Meta should be null for missing slot %s" % [i])

func test_get_most_recent_slot():
	# Should return slot with latest modified time
	# For now, just test it doesn't crash
	var recent_slot = _get_most_recent_slot()
	assert_true(recent_slot == null or (recent_slot >= 1 and recent_slot <= 3), 
		"Most recent slot should be null or 1-3")

# Helper functions to test (will be in actual SaveSlots class)
func _load_slot_meta(slot_num: int) -> Dictionary:
	var meta_path := "user://saves/slot_%s/meta.json" % [slot_num]
	if not FileAccess.file_exists(meta_path):
		return {}
	
	var file := FileAccess.open(meta_path, FileAccess.READ)
	if file == null:
		return {}
	
	var json_text := file.get_as_text()
	file.close()
	
	var json := JSON.new()
	if json.parse(json_text) != OK:
		return {}
	
	return json.data

func _get_most_recent_slot() -> int:
	var latest_slot := -1
	var latest_time := 0
	
	for i in range(1, 4):
		var meta_path := "user://saves/slot_%s/meta.json" % [i]
		if FileAccess.file_exists(meta_path):
			var file_time := FileAccess.get_modified_time(meta_path)
			if file_time > latest_time:
				latest_time = file_time
				latest_slot = i
	
	return latest_slot if latest_slot != -1 else 0
