extends KinematicBody2D


const TOPDOWN = Vector2(0, 0)

const MOVEMENTS = {
	'ui_up': Vector2.UP,
	'ui_left': Vector2.LEFT,
	'ui_right': Vector2.RIGHT,
	'ui_down': Vector2.DOWN,
}

onready var anim_tree = $tree
onready var anim_mode = anim_tree.get("parameters/playback")

var min_max = global.jsonify("res://media/json/sizes.json")

var direction_history = []
var motion = Vector2()
var speed = 400
var speed_mult = speed

var scr_div = 2.25

var size = {
	x = 1920,
	y = 1080
}

var max_size = 1
var min_size = 1

var max_vp
var min_vp


func _ready():
	var scene_name = get_tree().get_current_scene().get_name()
	
	speed_mult = min_max[scene_name]["speed"]
	
	min_vp = size.y - size.y / scr_div
	max_vp = size.y
	
	max_size = min_max[scene_name]["max"]
	min_size = min_max[scene_name]["min"]


func _physics_process(_delta):
	controlsLoop()
	movementLoop()

# Calculates movement for the player.
func movementLoop():
	motion = move_and_slide(motion * speed, TOPDOWN)

# Adds last pressed movement key to the direction_history array,
# then calculates the player's speed based on their size.
func controlsLoop():

	motion = Vector2()

	for direction in MOVEMENTS.keys():
		if Input.is_action_just_released(direction):
			var index = direction_history.find(direction)
			if index != -1:
				direction_history.remove(index)
		if Input.is_action_just_pressed(direction):
			direction_history.append(direction)
		
		var pl_scale = float(String(scale).replace('(', '').replace(')', '').left(4))
		
		speed = pl_scale * speed_mult

	if direction_history.size():
		var direction = direction_history[direction_history.size() - 1]
		motion = MOVEMENTS[direction]
		anim_tree.set("parameters/Walk/blend_position", motion.normalized())
		anim_tree.set("parameters/Idle/blend_position", motion.normalized())
		anim_mode.travel("Walk")
	else:
		anim_mode.travel("Idle")

# Called every frame.
func _process(_delta):
	if get_parent() is Node2D:
		calcScale()

# Calculates player's scale.
func calcScale():
	
	var ratio = (position.y - min_vp) / (max_vp - min_vp)
	var new_scale = interpolate(min_size, max_size, ratio)
	
	scale = Vector2(new_scale, new_scale)


func interpolate(minSize, maxSize, ratio):
	return minSize + (maxSize - minSize) * ratio
