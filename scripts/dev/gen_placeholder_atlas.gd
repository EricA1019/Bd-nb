extends SceneTree

# Generates a 256x256 CP437-style placeholder atlas (16x16 tiles, 256 glyphs) at user://assets/fonts/cp437_16x16.png
# Usage (headless):
#   godot --headless --path . -s res://scripts/dev/gen_placeholder_atlas.gd

func _initialize() -> void:
	var out_dir := "user://assets/fonts"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(out_dir))
	var img := Image.create(256, 256, false, Image.FORMAT_RGBA8)
	img.fill(Color.BLACK)
	# Draw a visible grid pattern so you can see tiles even as placeholders
	for y in img.get_height():
		for x in img.get_width():
			var edge := (x % 16 == 0) or (y % 16 == 0)
			if edge:
				img.set_pixel(x, y, Color(0.15, 0.15, 0.15, 1.0))
	# Put a white dot in the top-left pixel of each tile to help spot alignment
	for ty in 16:
		for tx in 16:
			var px := tx * 16
			var py := ty * 16
			img.set_pixel(px, py, Color(1, 1, 1, 1))
	var out_path := out_dir + "/cp437_16x16.png"
	var err := img.save_png(out_path)
	if err != OK:
		push_error("Failed to save placeholder atlas: %s" % out_path)
		quit(1)
	print("Placeholder atlas written:", out_path)
	quit()
