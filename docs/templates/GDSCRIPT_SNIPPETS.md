# GDScript Snippet Library (Testing & Patterns)

Assertions & GUT
```gdscript
extends "res://addons/gut/test.gd"

func test_eq():
	assert_eq(2+2, 4)

func test_almost():
	assert_almost_eq(0.1+0.2, 0.3, 0.0001)

func test_signals():
	var em = Node.new()
	var called = false
	em.connect("tree_entered", func(): called = true)
	get_tree().root.add_child(em)
	await get_tree().process_frame
	assert_true(called)
```

Orphan/leak hygiene
```gdscript
func after_each():
	assert_no_new_orphans()
```

Autoload getter
```gdscript
var _db := get_node("/root/DB")
```

Logging helper
```gdscript
Log.p("TurnMgr", ["start", units])
```

Signal bus pattern
```gdscript
# EventBus.gd (autoload)
extends Node
signal event(tag:String, payload:Variant)

static func emit(tag:String, payload:Variant=null):
	emit_signal("event", tag, payload)
```

Basic registry pattern
```gdscript
class_name AbilityReg
extends Node
var _by_name := {}

func register(res:Resource):
	_by_name[res.resource_name] = res

func get(name:String) -> Resource:
	return _by_name.get(name)
```
