extends Node

signal event(tag:String, payload:Variant)

func emit_event(tag:String, payload:Variant=null) -> void:
	emit_signal("event", tag, payload)
#EOF
