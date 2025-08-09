extends Node

var _migrated_version:int = 0
var _path:String = "user://bd.db"

func _ready() -> void:
	_print_log("DB", ["boot", "ensuring", _path])
	var ok: bool = _ensure_db()
	if not ok:
		push_error("[DB] Failed to initialize SQLite.")
		return
	_ensure_seed_data()
	_ensure_save_slots()

func get_schema_version() -> int:
	return _migrated_version

# Hop 5: API naming aliases (non-breaking)
func list_factions() -> Array:
	return get_factions()

func list_suffixes() -> Array:
	return get_suffixes()

func read_lore(key:String) -> String:
	return get_lore(key)

func read_ascii_art(key:String) -> String:
	return get_ascii_art(key)

# Hop 4: Data access helpers
func get_factions() -> Array:
	return _with_db_array(func(db):
		if db.query("SELECT key, name FROM factions ORDER BY id"):
			return db.query_result.duplicate()
		return []
	)

func get_suffixes() -> Array:
	return _with_db_array(func(db):
		if db.query("SELECT key, name, power FROM suffixes ORDER BY id"):
			return db.query_result.duplicate()
		return []
	)

func get_lore(key:String) -> String:
	var rows := _with_db_array(func(db):
		var q := "SELECT text FROM lore WHERE key='" + key + "' LIMIT 1"
		if db.query(q):
			return db.query_result.duplicate()
		return []
	)
	if rows.size() == 0:
		_ensure_seed_data()
		rows = _with_db_array(func(db):
			var q := "SELECT text FROM lore WHERE key='" + key + "' LIMIT 1"
			if db.query(q):
				return db.query_result.duplicate()
			return []
		)
	# Finalize value with fallback if empty
	var val := ""
	if rows.size() > 0 and rows[0].has("text"):
		val = str(rows[0]["text"])
	if val == "" and key == "intro":
		return "Waking in a narrow bed in New Babylon, the city hums below."
	return val

func get_ascii_art(key:String) -> String:
	var rows := _with_db_array(func(db):
		var q := "SELECT art FROM ascii_art WHERE key='" + key + "' LIMIT 1"
		if db.query(q):
			return db.query_result.duplicate()
		return []
	)
	if rows.size() == 0:
		_ensure_seed_data()
		rows = _with_db_array(func(db):
			var q := "SELECT art FROM ascii_art WHERE key='" + key + "' LIMIT 1"
			if db.query(q):
				return db.query_result.duplicate()
			return []
		)
	# Finalize value with fallback if empty
	var val := ""
	if rows.size() > 0 and rows[0].has("art"):
		val = str(rows[0]["art"])
	if val == "" and key == "title":
		return "BD:NB"
	return val

func _with_db_array(op:Callable) -> Array:
	var db := SQLite.new()
	db.path = _path
	if not db.open_db():
		return []
	var result: Variant = op.call(db)
	db.close_db()
	return result if typeof(result) == TYPE_ARRAY else []

# --- internals ---
func _ensure_db() -> bool:
	var db := SQLite.new()
	db.path = _path
	if not db.open_db():
		push_error("[DB] Could not open DB at " + _path)
		return false
	# Ensure schema_version exists before reading
	var ok: bool = db.query("CREATE TABLE IF NOT EXISTS schema_version (version INTEGER NOT NULL)")
	if not ok:
		push_error("[DB] Failed to ensure schema_version table")
		db.close_db()
		return false
	# Determine current version
	var cur: int = _read_version(db)
	# Apply migrations in order if needed
	var applied: bool = _apply_migrations(db, cur)
	if not applied:
		_print_log("DB", ["no_migrations", "current=", cur])
	_migrated_version = _read_version(db)
	_print_log("DB", ["version", _migrated_version])
	db.close_db()
	return true

func _ensure_seed_data() -> void:
	var db := SQLite.new()
	db.path = _path
	if not db.open_db():
		return
	# Create tables if plugin skipped 0002 (idempotent)
	db.query("CREATE TABLE IF NOT EXISTS factions (id INTEGER PRIMARY KEY AUTOINCREMENT, key TEXT UNIQUE NOT NULL, name TEXT NOT NULL)")
	db.query("CREATE TABLE IF NOT EXISTS suffixes (id INTEGER PRIMARY KEY AUTOINCREMENT, key TEXT UNIQUE NOT NULL, name TEXT NOT NULL, power INTEGER NOT NULL DEFAULT 0)")
	db.query("CREATE TABLE IF NOT EXISTS lore (id INTEGER PRIMARY KEY AUTOINCREMENT, key TEXT UNIQUE NOT NULL, text TEXT NOT NULL)")
	db.query("CREATE TABLE IF NOT EXISTS ascii_art (id INTEGER PRIMARY KEY AUTOINCREMENT, key TEXT UNIQUE NOT NULL, art TEXT NOT NULL)")
	# Seeds (OR IGNORE)
	db.query("INSERT OR IGNORE INTO factions (key, name) VALUES ('imps','Imps')")
	db.query("INSERT OR IGNORE INTO factions (key, name) VALUES ('angels','Angels')")
	db.query("INSERT OR IGNORE INTO suffixes (key, name, power) VALUES ('brave','Brave',1)")
	db.query("INSERT OR IGNORE INTO suffixes (key, name, power) VALUES ('cursed','Cursed',-1)")
	db.query("INSERT OR IGNORE INTO lore (key, text) VALUES ('intro','Waking in a narrow bed in New Babylon, the city hums below.')")
	db.query("INSERT OR IGNORE INTO ascii_art (key, art) VALUES ('title','BD:NB')")
	# Ensure non-empty seed values for known keys
	db.query("UPDATE lore SET text='Waking in a narrow bed in New Babylon, the city hums below.' WHERE key='intro' AND (text IS NULL OR text='')")
	db.query("UPDATE ascii_art SET art='BD:NB' WHERE key='title' AND (art IS NULL OR art='')")
	db.close_db()

func _read_version(db) -> int:
	var v:int = 0
	if db.query("SELECT version FROM schema_version LIMIT 1"):
		if db.query_result.size() > 0 and db.query_result[0].has("version"):
			v = int(db.query_result[0]["version"])
	return v

func _apply_migrations(db, current:int) -> bool:
	var dir:String = "res://data/sql"
	var da := DirAccess.open(dir)
	if da == null:
		push_warning("[DB] Cannot open migrations dir: " + dir)
		return false
	var files: Array = []
	da.list_dir_begin()
	var f := da.get_next()
	while f != "":
		if not da.current_is_dir() and f.ends_with(".sql"):
			files.append(f)
		f = da.get_next()
	da.list_dir_end()
	files.sort() # lexicographic: 0001_*.sql, 0002_*.sql, ...
	var applied_any := false
	for fname in files:
		var s:String = str(fname)
		var uscore:int = s.find("_")
		var dot:int = s.rfind(".")
		if dot == -1:
			dot = s.length()
		var cut:int = uscore
		if cut == -1:
			cut = dot
		var idx:int = int(s.substr(0, cut))
		if idx <= current:
			continue
		var sql_path:String = dir + "/" + s
		var sql:String = FileAccess.get_file_as_string(sql_path)
		if sql.is_empty():
			continue
		for stmt in _split_sql(sql):
			if stmt.is_empty():
				continue
			if not db.query(stmt):
				push_error("[DB] Migration failed at " + s + ": " + stmt)
				return applied_any
		applied_any = true
	# If migrations did not set version, set to max index applied
	if applied_any:
		var new_version:int = _read_version(db)
		if new_version <= current:
			var max_idx:int = 0
			for fname2 in files:
				var s2:String = str(fname2)
				var us2:int = s2.find("_")
				var d2:int = s2.rfind(".")
				if d2 == -1:
					d2 = s2.length()
				var cut2:int = us2
				if cut2 == -1:
					cut2 = d2
				var idx2:int = int(s2.substr(0, cut2))
				if idx2 > max_idx:
					max_idx = idx2
			# Upsert schema_version
			db.query("DELETE FROM schema_version")
			db.query("INSERT INTO schema_version (version) VALUES (" + str(max_idx) + ")")
	return applied_any

func _split_sql(sql:String) -> Array:
	var lines := sql.split("\n")
	var buf := ""
	var stmts: Array = []
	for ln in lines:
		var t := (ln as String).strip_edges()
		if t.begins_with("--") or t.is_empty():
			continue
		buf += t + "\n"
		if t.ends_with(";"):
			stmts.append(buf)
			buf = ""
	# tail
	if not buf.strip_edges().is_empty():
		stmts.append(buf)
	return stmts

func _ensure_save_slots() -> void:
	var base:String = "user://saves"
	DirAccess.make_dir_recursive_absolute(base)
	for i in range(1, 4): # slots 1..3
		var slot:String = base + "/slot_" + str(i)
		DirAccess.make_dir_recursive_absolute(slot)
		var meta_path:String = slot + "/meta.json"
		if not FileAccess.file_exists(meta_path):
			var meta := {
				"slot": i,
				"name": "",
				"playtime": 0,
				"location": "",
				"created": Time.get_unix_time_from_system(),
				"version": 1
			}
			var fa := FileAccess.open(meta_path, FileAccess.WRITE)
			fa.store_string(JSON.stringify(meta, "\t"))
			fa.close()
	_print_log("DB", ["saves_ready"]) 

func _print_log(tag:String, parts:Array) -> void:
	# Local print helper to avoid autoload dependency at parse time.
	var msg := "[" + tag + "] "
	for p in parts:
		msg += str(p) + " "
	print(msg.strip_edges())
#EOF
