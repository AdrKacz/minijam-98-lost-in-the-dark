extends Spatial

export (PackedScene) var Wall : PackedScene

export (int, 1, 50) var w : int = 10 # width of the maze
export (int, 1, 50) var h : int = 10 # height of the maze
export (float, 0, 1) var p : float = 0.6 # probability of being filled

onready var ground : StaticBody = $Ground

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	var map : Array = generate_random_map()
	display_map(map)
	
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
				if (x_new >= 0 and x_new < w and y_new >= 0 and y_new < h):
					if map[y_new][x_new] == 'goal':
						return true
					elif map[y_new][x_new].length() == 0:
						search.append(str(x_new) + '.' + str(y_new))
						
	return false

func generate_random_map() -> Array:
	print('Searching a map ...')
	var map : Array = []
	while true:
		map.clear()
		for i in range(h):
			var map_i : Array = []
			for j in range(w):
				if randf() < p:
					map_i.append('wall')
				else:
					map_i.append('')
			map.append(map_i)
		
		map[0][0] = 'start'
		map[h - 1][w - 1] = 'goal'
		if is_valid_map(map):
			break
	print('Found ...')
	return map
	
func display_map(map : Array) -> void:
	# Extend and shift ground
	ground.translate(Vector3(w - 1, 0, h - 1))
	ground.scale.x = w
	ground.scale.z = h
	# Create wall
	var dx : int = 2
	var dy : int = 2
	var dz : int = 2
	for i in map.size():
		for j in map[i].size():
			if map[i][j] == 'wall':
				var wall : StaticBody = Wall.instance()
				wall.translate(Vector3(j * dx, dy, i * dz))
				add_child(wall)
