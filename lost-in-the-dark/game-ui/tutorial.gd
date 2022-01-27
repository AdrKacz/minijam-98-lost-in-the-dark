extends MarginContainer


var is_listening : bool = false



# What to teach
# First looking around and aiming > level 1
var has_moved_mouse : bool = false
var has_moved_forward : bool = false
var has_moved_backwards: bool = false
var has_moved_left: bool = false
var has_moved_right : bool = false
# Restart > if blocked
var has_restard : bool = false
# Move mid-air > level 5

var flag_controller : bool = false
var last_controller_rotation_y : float
onready var controller : KinematicBody = get_node_or_null("/root/World/Controller")
onready var label : Label = $CenterContainer/Label

var flag = false

func _process(_delta):
	if Global.best_score > 4:
		return
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		hide()
		return
		
	if Global.score <= 4:
		show()
		
	if Global.score == 0:
		# Get initial position of controller
		if not flag_controller:
			flag_controller = true
			last_controller_rotation_y = controller.rotation_degrees.y
			return
		if not has_moved_mouse:
			if abs(controller.rotation_degrees.y - last_controller_rotation_y) > 30:
				has_moved_mouse = true
			else:
				label.text = "Use your mouse to look around"
		elif not has_moved_forward:
			if controller.direction.z > 0:
				has_moved_forward = true
			else:
				label.text = "Use Z/W/Up to move forward"
		elif not has_moved_backwards:
			if controller.direction.z < 0:
				has_moved_backwards = true
			else:
				label.text = "Use S/Down to move backwards"
		elif not has_moved_left:
			if controller.direction.x < 0:
				has_moved_left = true
			else:
				label.text = "Use Q/A/Left to move left"
		elif not has_moved_right:
			if controller.direction.x > 0:
				has_moved_right = true
			else:
				label.text = "Use D/Right to move right"
		else:
			label.text = "Reach the light as fast as you can!\n\nIf you die, you'll restart the maze"
	elif Global.score == 1:
		label.text = "If you're stuck, just hit R to restart the maze"
	elif Global.score == 2:
		label.text = "Try to move mid-air to go faster!"
	elif Global.score == 3:
		label.text = "Keep an eye on the time remaining!\n\nYou can see how far you went in the top-left corner"
	elif Global.score == 4:
		label.text = "You're on your own now. Good luck!"
	
	
	
