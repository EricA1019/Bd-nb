# GDScript Snippet Library (Testing & Patterns)

Assertions & GUT
```gdscript
extends GutTest

func test_eq():
	assert_eq(2+2, 4)

func test_almost():
	assert_almost_eq(0.1+0.2, 0.3, 0.0001)

func test_signals():
	var em := Node.new()
	watch_signals(em)                # enable signal assertions
	add_child_autofree(em)           # ensure cleanup after test
	get_tree().root.add_child(em)
	await get_tree().process_frame
	assert_signal_emitted(em, "tree_entered")
```

Orphan/leak hygiene
```gdscript
func after_each():
	assert_no_new_orphans()
```

Autoload getter
```gdscript
@onready var _db: Node = get_node("/root/DB") # if not autoloaded as `DB`
```

SaveService access (safe)
```gdscript
func _svc() -> Node:
	return get_node_or_null("/root/SaveService")

func _ready():
	var svc := _svc()
	if svc:
		svc.call("set_current_slot", 1)
		svc.call("start_session")
```

Logging helper
```gdscript
Log.p("TurnMgr", ["start", units])
```

Signal bus pattern
```gdscript
# EventBus.gd (autoload)
extends Node
signal event(tag: String, payload: Variant)

func emit_event(tag: String, payload: Variant = null) -> void:
	emit_signal("event", tag, payload)
```

Basic registry pattern
```gdscript
class_name AbilityReg
extends Node
var _by_name: Dictionary = {}

func register(res: Resource) -> void:
	_by_name[res.resource_name] = res

func get(name: String) -> Resource:
	return _by_name.get(name)

func has(name: String) -> bool:
	return _by_name.has(name)

func unregister(name: String) -> void:
	_by_name.erase(name)
```

UI TopBar playtime mm:ss
```gdscript
func _process(delta: float) -> void:
	var svc := get_node_or_null("/root/SaveService")
	if not svc:
		return
	svc.call("add_session_seconds", delta)
	var lbl := get_node_or_null("UIRoot/TopBar/TopBarLabel")
	if lbl:
		var seconds := int(svc.call("get_display_playtime_seconds"))
		var mm: int = int(float(seconds) / 60.0)
		var ss: int = seconds % 60
		var slot: int = int(svc.call("get_current_slot"))
		var slot_s := str(slot) if slot > 0 else "-"
		lbl.text = "Slot: %s | Playtime %02d:%02d" % [slot_s, mm, ss]
```
