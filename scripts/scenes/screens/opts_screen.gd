extends Control


onready var lang_opts = $menu/lang/lang_opts
onready var size = $menu/scr/size
onready var mode = $menu/scr/mode
onready var bgm_slider = $menu/sound/bgm_slider
onready var sfx_slider = $menu/sound/sfx_slider

var click = preload("res://media/ogg/terminal/beep.ogg")
var translate = global.jsonify("res://media/json/langs/screens/opts_screen.json")


func _ready():
	generate_items(
		["English", "Español", "Esperanton"],
		["1920x1080", "1280x720"],
		translate[global.current_lang]["content"]["scr-mode"]
	)
	
	$bg/title.text = translate[global.current_lang]["content"]["title"]
	$menu/lang/title.text = translate[global.current_lang]["content"]["lang"]
	$menu/scr/title.text = translate[global.current_lang]["content"]["scr"]
	$menu/sound/title.text = translate[global.current_lang]["content"]["sound"]
	$menu/sound/bgm.text = translate[global.current_lang]["content"]["bgm"]
	$menu/sound/sfx.text = translate[global.current_lang]["content"]["sfx"]
	
	bgm_slider.value = global.bgm_volume
	sfx_slider.value = global.sfx_volume


func generate_items(langs, sizes, modes):
	for i in langs:
		lang_opts.add_item(i)
	
	var curr
	match global.current_lang:
		"en":
			curr = 0
		"es":
			curr = 1
		"eo":
			curr = 2
	
	lang_opts.select(curr)
	
	for i in sizes:
		size.add_item(i)
	
	size.select(0)
	
	for i in modes:
		mode.add_item(i)
	
	mode.select(global_viewport.current_mode)


# Options (Lang)
func _on_lang_opts_item_selected(index):
	global.play_sound(click, 'sfx')
	match index:
		0:
			global.current_lang = "en"
		1:
			global.current_lang = "es"
		2:
			global.current_lang = "eo"
	
	assert(get_tree().reload_current_scene() == OK)

# Options (Screen)
func _on_size_item_selected(index):
	global.play_sound(click, 'sfx')
	match index:
		0:
			pass
		1:
			pass

func _on_mode_item_selected(index):
	global.play_sound(click, 'sfx')
	match index:
		0:
			global_viewport.set_fullscreen()
		1:
			global_viewport.set_windowed()

# Sliders (Volume)
func _on_bgm_slider_value_changed(value):
	global.bgm_volume = value
	global.change_volume(value, 2)

func _on_sfx_slider_value_changed(value):
	global.sfx_volume = value
	global.change_volume(value, 1)

# Exit
func _on_exit_pressed():
	global.play_sound(click, 'sfx')
	global.change_scene("res://scenes/screens/title_screen.tscn")
