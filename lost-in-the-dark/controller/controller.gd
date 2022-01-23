extends KinematicBody

signal hit_restart

export (float) var max_speed : float = 20
export (float) var acceleration : float = 4.5
export (float) var deacceleration : float = 16
export (float) var mouse_sensitivity : float = 0.1
export (float) var gravity : float = -24.8
export (float) var max_slope_angle : float = 40 # in degrees, all is flat just to not be blocked

var velocity : Vector3 = Vector3()
var direction : Vector3 = Vector3()

onready var camera : Camera = $Camera
onready var audio_footsteps : AudioStreamPlayer = $AudioFootsteps

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	process_input()
	process_movement(delta)
	process_sound()
	
func process_input():
	# Restart ?
	if Input.is_action_just_pressed("restart"):
		emit_signal("hit_restart")
	# Walking
	direction = Vector3()
	var camera_xform : Transform = camera.global_transform
	var input_movement_vector : Vector2 = Vector2()
	
	if Input.is_action_pressed("ui_up"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("ui_down"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("ui_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_movement_vector.x += 1
	input_movement_vector = input_movement_vector.normalized()
	
	direction += -camera_xform.basis.z * input_movement_vector.y
	direction += camera_xform.basis.x * input_movement_vector.x
	
	# Capturing / Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func process_movement(delta):
	direction.y = 0
	direction = direction.normalized()
	
	velocity.y += delta * gravity
	
	var horizontal_velocity: Vector3 = velocity
	horizontal_velocity.y = 0
	
	var target : Vector3 = direction
	target *= max_speed
	
	var current_acceleration : float
	if direction.dot(horizontal_velocity) > 0:
		current_acceleration = acceleration
	else:
		current_acceleration = deacceleration
	
	horizontal_velocity = horizontal_velocity.linear_interpolate(target, current_acceleration * delta)
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z
	velocity = move_and_slide(velocity, Vector3(0, 1, 0), 0.05, 4, deg2rad(max_slope_angle))
	
func process_sound():
	if is_on_floor() and direction.length_squared() > 0:
		audio_footsteps.is_playing = true
	else:
		audio_footsteps.is_playing = false
	
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		camera.rotate_x(deg2rad(event.relative.y * mouse_sensitivity))
		rotate_y(deg2rad(event.relative.x * mouse_sensitivity * -1))
		var camera_rot = camera.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		camera.rotation_degrees = camera_rot 
