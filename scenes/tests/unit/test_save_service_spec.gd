extends "res://addons/gut/test.gd"

# Removed global clears to avoid interfering with other tests

func after_each():
	assert_no_new_orphans()

func test_save_service_api_and_paths():
	var Svc = load("res://scripts/systems/SaveService.gd")
	assert_not_null(Svc, "SaveService script should exist")
	var svc = Svc.new()
	add_child_autoqfree(svc)
	# Meta template should have expected fields
	var meta = svc.meta_template(1)
	assert_true(meta.has("slot"), "meta has slot")
	assert_true(meta.has("created_at"), "meta has created_at")
	assert_true(meta.has("updated_at"), "meta has updated_at")
	assert_true(meta.has("version"), "meta has version")
	assert_true(meta.has("playtime_seconds"), "meta has playtime_seconds")
	assert_true(meta.has("save_count"), "meta has save_count")
	# Path helpers
	assert_eq(svc._slot_path(2), "user://saves/slot_2", "slot path correct")
	assert_eq(svc._meta_path(3), "user://saves/slot_3/meta.json", "meta path correct")

func test_force_save_creates_meta_and_increments_playtime():
	var Svc = load("res://scripts/systems/SaveService.gd")
	assert_not_null(Svc, "SaveService script should exist")
	var svc = Svc.new()
	add_child_autoqfree(svc)
	svc.set_current_slot(1)
	svc.start_session()
	svc.force_save(2) # add 2s
	var meta_path := "user://saves/slot_1/meta.json"
	assert_true(FileAccess.file_exists(meta_path), "meta written")
	var data := _read_json(meta_path)
	assert_eq(data.slot, 1)
	assert_true(int(data.playtime_seconds) >= 2, "playtime accumulates")
	assert_true(int(data.save_count) >= 1, "save_count increments")

# helpers
func _read_json(p:String) -> Dictionary:
	var txt := FileAccess.get_file_as_string(p)
	var j := JSON.new()
	var ok := j.parse(txt)
	assert_eq(ok, OK, "json parse ok")
	return j.data
