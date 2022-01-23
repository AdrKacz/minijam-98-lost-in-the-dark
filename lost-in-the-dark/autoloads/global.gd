extends Node

var menu_scene_path : String = "res://menu/menu.tscn"
var game_scene_path : String = "res://world/world.tscn"

var time_max : float = 30
var time_left : float = time_max
var score : int = -1 # -1 at start so you can score 0 later ..
var best_score : int = 0
var random_seed : int = 0
var width : int = 1
var height : int = 1
var current_seed : int = 0
var current_state : int = 0

onready var random_number_generator : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	randomize()
	randomize_random_number_generator()
	
func randomize_random_number_generator() -> void:
	random_number_generator.randomize()
	current_seed = random_number_generator.seed
	current_state = random_number_generator.state

func reset_seed() -> void:
	random_number_generator.seed = current_seed
	random_number_generator.state = current_state
	

func reset_score() -> void:
	score = 0
	
func reset_time() -> void:
	time_left = time_max
	
func update_score(delta : int) -> void:
	score += delta
	if score > best_score:
		best_score = score
	
func set_dimension(w : int, h : int) -> void:
	width = w
	height = h
	
func reload_scene() -> void:
	var err : int = get_tree().reload_current_scene()
	if err != 0:
		print('[reload_scene] Something went wrong, error code: ', err)
	
func load_game_scene() -> void:
	var err : int = get_tree().change_scene(game_scene_path)
	if err != 0:
		print('[reload_scene] Something went wrong, error code: ', err)
	
func load_menu_scene() -> void:
	var err : int = get_tree().change_scene(menu_scene_path)
	if err != 0:
		print('[reload_scene] Something went wrong, error code: ', err)
	
func _process(delta) -> void:
	if time_left < 0:
		return
	time_left -= delta
	
func get_time_left() -> float:
	return max(time_left, 0)
	
