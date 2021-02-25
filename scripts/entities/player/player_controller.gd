extends KinematicBody2D


const TOPDOWN = Vector2(0, 0)

const MOVEMENTS = {
	'ui_up': Vector2.UP,
	'ui_left': Vector2.LEFT,
	'ui_right': Vector2.RIGHT,
	'ui_down': Vector2.DOWN,
}

var direction_history = []
var motion = Vector2()
var speed = 400

var scr_div = 2.25

var size = {
	x = 1920,
	y = 1080
}

var breakpoints = []

var max_vp
var min_vp

var max_size = 1
var min_size = 0.2


func _ready():
	if get_tree().get_current_scene().get_name() == 'Mundo':
		breakpoints = [0.35, 0.3, 0.29]
	
	min_vp = size.y - size.y / scr_div
	max_vp = size.y


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
		
		speed = pl_scale * 400

	if direction_history.size():
		var direction = direction_history[direction_history.size() - 1]
		motion = MOVEMENTS[direction]

# Called every frame.
func _process(_delta):
	if get_parent() is Node2D:
		calcScale()

# Calculates player's scale.
func calcScale():
	
	var ratio = (position.y - min_vp) / (max_vp - min_vp)
	var new_scale = interpolate(min_size, max_size, ratio)
	
	scale = Vector2(new_scale, new_scale)

# Interpolates player scale change, so it doesn't look rough.
func interpolate(minSize, maxSize, ratio):
	return minSize + (maxSize - minSize) * ratio
