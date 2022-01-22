extends Spatial

export (PackedScene) var Ground : PackedScene
export (PackedScene) var Wall : PackedScene
export (PackedScene) var Goal : PackedScene

export (int, 1, 50) var width : int = 10 # width of the maze
export (int, 1, 50) var height : int = 10 # height of the maze
export (float, 0, 1) var p : float = 0.6 # probability of being filled
export (float, 5, 50) var spawn_height = 20 # height where the controller is created


# Problem with signal send from goal, need only one goal, to correct !
onready var game_ui : Control = $GameUI
onready var environment : Spatial = $Environment
onready var controller : KinematicBody = $Controller
onready var goal : Spatial = $Goal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Create new world
	var map : Array = generate_random_map()
	display_map(map)
	controller.translation = Vector3(0, spawn_height, 0)
	
func is_valid_map(map : Array) -> bool:
	# Returns true if the given map has at least one path
	var search : Array = []
	var discovered : Dictionary = {}
	
	search.append('0.0') # Starting point
	while search.size() > 0:
		var look : String = search.pop_back()
		if not discovered.has(look):
			discovered[look] = true
			var xy : Array = look.split('.')
			var x : int = int(xy[0])
			var y : int = int(xy[1])
			for direction in ['-1.0', '1.0', '0.-1', '0.1']:
				var x_new = x + int(direction[0])
				var y_new = y + int(direction[1])
				if (x_new >= 0 and x_new < width and y_new >= 0 and y_new < height):
					if map[y_new][x_new] == 'goal':
						return true
					elif map[y_new][x_new] == 'ground':
						search.append(str(x_new) + '.' + str(y_new))
						
	return false

func generate_random_map() -> Array:
	print('Searching a map ...')
	var map : Array = []
	while true:
		map.clear()
		for _i in range(height):
			var map_i : Array = []
			for _j in range(width):
				if Global.random_number_generator.randf() < p:
					map_i.append('wall')
				else:
					map_i.append('ground')
			map.append(map_i)
		
		map[0][0] = 'ground'
		map[height - 1][width - 1] = 'goal'
		if is_valid_map(map):
			break
	print('Found ...')
	return map
	
func display_obj(obj : String, i : int, j : int) -> void:
	var dx : int = 2
	var dy : int = 2
	var dz : int = 2
	match obj:
		'wall':
			var wall : StaticBody = Wall.instance()
			wall.translate(Vector3(j * dx, dy, i * dz))
			environment.add_child(wall)
		'ground':
			var ground = Ground.instance()
			ground.translate(Vector3(j * dx, 0, i * dz))
			environment.add_child(ground)
		'goal':
			goal.translate(Vector3(j * dx, 0, i * dz))
		_:
			print('Object cannot be display: ', obj) 
	
func display_map(map : Array) -> void:
	# Create map
	for i in map.size():
		for j in map[i].size():
			if map[i][j] == 'wall':
				display_obj('wall', i, j)
			elif map[i][j] == 'ground':
				display_obj('ground', i, j)
			elif map[i][j] == 'goal':
				display_obj('ground', i, j)
				display_obj('goal', i, j)

# Check if controller stil on map
func _physics_process(_delta):
	if controller.translation.y < -1:
		print('You fall!')
		seed(str(Global.current_seed).hash())
		Global.reset_seed()
		Global.reload_scene()


func _on_Goal_controller_touch_it():
	Global.update_score(1)
	Global.randomize_random_number_generator()
	Global.reload_scene()


func _on_Controller_hit_restart():
	Global.reset_seed()
	Global.reload_scene()
