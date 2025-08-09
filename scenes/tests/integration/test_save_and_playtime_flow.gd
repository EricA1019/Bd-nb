extends "res://addons/gut/test.gd"

func after_each():
	assert_no_new_orphans()

func _svc() -> Node:
	return get_node_or_null("/root/SaveService")

func _read_json(p:String) -> Dictionary:
	var txt := FileAccess.get_file_as_string(p)
	var j := JSON.new()
	var ok := j.parse(txt)
	assert_eq(ok, OK, "json parse ok")
	return j.data

func test_f5_force_save_updates_meta():
	var svc: Node = _svc()
	assert_not_null(svc, "SaveService autoload present")
	svc.call("set_current_slot", 1)
	svc.call("start_session")
	svc.call("force_save", 0) # ensure meta exists
	# add 3 seconds and trigger F5
	svc.call("add_session_seconds", 3.0)
	var main_scene: Node = load("res://scenes/Main.tscn").instantiate()
	add_child_autoqfree(main_scene)
	await get_tree().process_frame
	# send F5
	var ev := InputEventKey.new()
	ev.keycode = KEY_F5
	ev.pressed = true
	(main_scene as Node)._unhandled_input(ev)
	await get_tree().process_frame
	var meta_path := "user://saves/slot_1/meta.json"
	assert_true(FileAccess.file_exists(meta_path), "meta exists")
	var data := _read_json(meta_path)
	assert_true(int(data.playtime_seconds) >= 3, "playtime saved >= 3s after F5")
	assert_true(int(data.save_count) >= 1, "save_count incremented")

func test_exit_from_main_triggers_save():
	var svc: Node = _svc()
	assert_not_null(svc)
	svc.call("set_current_slot", 1)
	svc.call("start_session")
	svc.call("force_save", 0)
	svc.call("add_session_seconds", 2.0)
	var before := int(_read_json("user://saves/slot_1/meta.json").get("save_count", 0))
	var main_scene: Node = load("res://scenes/Main.tscn").instantiate()
	add_child_autoqfree(main_scene)
	await get_tree().process_frame
	# Change scene to Title; Main should save on exit
	get_tree().change_scene_to_file("res://scenes/ui/TitleScreen.tscn")
	await get_tree().process_frame
	var after := int(_read_json("user://saves/slot_1/meta.json").get("save_count", 0))
	assert_true(after > before, "save_count increased on exit")
