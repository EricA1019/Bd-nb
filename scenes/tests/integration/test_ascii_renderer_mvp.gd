extends "res://addons/gut/test.gd"

func after_each():
	assert_no_new_orphans()

func test_renderer_sets_shader_textures_after_render_buffer():
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	add_child_autoqfree(main)
	await get_tree().process_frame
	var ascii = main.get_node("UIRoot").find_child("Ascii", true, false)
	assert_not_null(ascii, "Ascii node present")
	# Create a buffer and draw a single visible glyph
	var buf = ascii.call("create_buffer")
	assert_not_null(buf)
	var TermCell = preload("res://addons/Godot-4-ASCII-Grid/addons/ascii_grid/term_cell.gd")
	buf.put_cell(TermCell.new("*", Color(1,1,1,1), Color(0,0,0,1)), Vector2i(0,0))
	ascii.call("render_buffer", buf)
	await get_tree().process_frame
	# Grab the internal TermRect and inspect shader params
	var term_rect = ascii.get_node("TermRect")
	assert_not_null(term_rect, "TermRect child exists")
	var mat: ShaderMaterial = term_rect.material
	assert_not_null(mat, "ShaderMaterial present")
	var glyphs = mat.get_shader_parameter("glyphs")
	var char_grid = mat.get_shader_parameter("character_grid")
	var fg_tex = mat.get_shader_parameter("fg_color")
	var bg_tex = mat.get_shader_parameter("bg_color")
	assert_not_null(glyphs, "glyph atlas bound")
	assert_not_null(char_grid, "character grid set")
	assert_not_null(fg_tex, "fg texture set")
	assert_not_null(bg_tex, "bg texture set")
	# Clean up explicitly
	main.queue_free()
	await get_tree().process_frame
