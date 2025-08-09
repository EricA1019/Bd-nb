extends RefCounted

var _size: Vector2i

func _init(size: Vector2i):
	_size = size

func get_draw_region() -> Rect2i:
	return Rect2i(Vector2i.ZERO, _size)
