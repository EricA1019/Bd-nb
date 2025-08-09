extends Node

var _current_slot:int = 0
var _session_seconds: float = 0.0

func set_current_slot(slot:int) -> void:
	_current_slot = clampi(slot, 1, 3)
	_ensure_slot_dirs(_current_slot)

func current_slot() -> int:
	return _current_slot

func get_current_slot() -> int:
	return _current_slot

func start_session() -> void:
	_session_seconds = 0.0

func stop_session() -> void:
	_session_seconds = 0.0

func add_session_seconds(sec: float) -> void:
	_session_seconds += maxf(sec, 0.0)

func get_session_seconds() -> int:
	return int(_session_seconds)

func get_display_playtime_seconds() -> int:
	if _current_slot <= 0:
		return int(_session_seconds)
	var meta := read_meta(_current_slot)
	var base := int(meta.get("playtime_seconds", 0)) if typeof(meta) == TYPE_DICTIONARY else 0
	return base + int(_session_seconds)

func force_save(add_seconds: float = 0.0) -> void:
	if _current_slot <= 0:
		set_current_slot(1)
	if add_seconds > 0.0:
		_session_seconds += add_seconds
	var meta := read_meta(_current_slot)
	if meta.is_empty():
		meta = meta_template(_current_slot)
	# accumulate playtime and bump save count
	meta.playtime_seconds = int((meta.get("playtime_seconds", 0)) + _session_seconds)
	meta.save_count = int(meta.get("save_count", 0)) + 1
	meta.updated_at = Time.get_unix_time_from_system()
	write_meta(_current_slot, meta)
	# reset per-save accumulation
	_session_seconds = 0.0

func meta_template(slot:int) -> Dictionary:
	var now := Time.get_unix_time_from_system()
	return {
		"slot": slot,
		"created_at": now,
		"updated_at": now,
		"version": 1,
		"playtime_seconds": 0,
		"save_count": 0
	}

func read_meta(slot:int) -> Dictionary:
	var p := _meta_path(slot)
	if not FileAccess.file_exists(p):
		return {}
	var txt := FileAccess.get_file_as_string(p)
	if txt.is_empty():
		return {}
	var j := JSON.new()
	var ok := j.parse(txt)
	if ok != OK:
		return {}
	if typeof(j.data) == TYPE_DICTIONARY:
		return j.data
	return {}

func write_meta(slot:int, meta:Dictionary) -> bool:
	_ensure_slot_dirs(slot)
	var p := _meta_path(slot)
	var f := FileAccess.open(p, FileAccess.WRITE)
	if f == null:
		push_error("[SaveService] Failed to open meta for write: " + p)
		return false
	f.store_string(JSON.stringify(meta, "\t"))
	f.close()
	return true

func get_latest_slot() -> int:
	var latest_slot := 0
	var latest_time := 0
	for i in range(1,4):
		var p := _meta_path(i)
		if FileAccess.file_exists(p):
			var t := FileAccess.get_modified_time(p)
			if t > latest_time:
				latest_time = t
				latest_slot = i
	return latest_slot

# --- paths/helpers ---
func _slot_path(slot:int) -> String:
	return "user://saves/slot_%s" % [slot]

func _meta_path(slot:int) -> String:
	return _slot_path(slot) + "/meta.json"

func _ensure_slot_dirs(slot:int) -> void:
	DirAccess.make_dir_recursive_absolute("user://saves")
	DirAccess.make_dir_recursive_absolute(_slot_path(slot))
