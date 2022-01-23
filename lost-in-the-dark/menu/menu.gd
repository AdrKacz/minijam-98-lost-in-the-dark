extends Spatial


export (PackedScene) var Ground : PackedScene
export (PackedScene) var Wall : PackedScene

onready var environment : Spatial = $Environment
onready var fire : Spatial = $Fire

func _ready():
	# Camera is in 0.0 minus offsets (see args 2 and 3),  looking right
	display_map([
		['ground', 'ground', 'ground', 'wall', 'wall', 'wall'],
		['ground', 'ground', 'ground', 'ground', 'ground', 'wall'],
		['ground', 'ground', 'ground', 'fire', 'ground', 'wall'],
		['ground', 'ground', 'ground', 'ground', 'ground', 'wall'],
		['ground', 'ground', 'ground', 'wall', 'wall', 'wall'],
	], -1, -2)


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
		'fire':
			fire.translate(Vector3(j * dx, 0, i * dz))
		_:
			print('Object cannot be display: ', obj) 
	
func display_map(map : Array, x_offset : int, y_offset : int) -> void:
	# Create map
	for i in map.size():
		for j in map[i].size():
			if map[i][j] == 'wall':
				display_obj('wall', i + y_offset, j + x_offset)
			elif map[i][j] == 'ground':
				display_obj('ground', i + y_offset, j + x_offset)
			elif map[i][j] == 'fire':
				display_obj('ground', i + y_offset, j + x_offset)
				display_obj('fire', i + y_offset, j + x_offset)
			elif map[i][j] == 'camera':
				display_obj('ground', i + y_offset, j + x_offset)
				display_obj('camera', i + y_offset, j + x_offset)
