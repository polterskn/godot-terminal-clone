extends Control


onready var begin = $menu/begin
onready var opts = $menu/opts
onready var quit = $menu/quit

var click = preload("res://media/ogg/terminal/beep.ogg")
var translate = global.jsonify("res://media/json/langs/screens/title_screen.json")

var b_holder
var o_holder
var q_holder


func _ready():
	b_holder = translate[global.current_lang]["content"]["begin"]
	o_holder = translate[global.current_lang]["content"]["opts"]
	q_holder = translate[global.current_lang]["content"]["quit"]
	begin.text = '-' + b_holder
	opts.text = '-' + o_holder
	quit.text = '-' + q_holder

# begin
func _on_begin_mouse_entered():
	begin.text = '>' + b_holder

func _on_begin_mouse_exited():
	begin.text = '-' + b_holder

func _on_begin_pressed():
	global.play_sound(click, 'sfx')

# opts
func _on_opts_mouse_entered():
	opts.text = '>' + o_holder

func _on_opts_mouse_exited():
	opts.text = '-' + o_holder

func _on_opts_pressed():
	global.play_sound(click, 'sfx')
	global.change_scene("res://scenes/screens/opts_screen.tscn")

# quit
func _on_quit_mouse_entered():
	quit.text = '>' + q_holder

func _on_quit_mouse_exited():
	quit.text = '-' + q_holder

func _on_quit_pressed():
	get_tree().quit()
