extends Node

var menu_scene_path : String = "res://menu/menu.tscn"
var game_scene_path : String = "res://world/world.tscn"

var width : int = 10
var height : int = 10
var p : float = 0.4
var time_max : float = 30

var time_left : float = time_max
var score : int = -1 # -1 at start so you can score 0 later ..
var best_score : int = 0

var random_seed : int = 0
var current_seed : int = 0
var current_state : int = 0

var last_stream_position : float = 0
var is_sound : bool = false

onready var random_number_generator : RandomNumberGenerator = RandomNumberGenerator.new()

onready var audio_stream_player : AudioStreamPlayer = $AudioStreamPlayer
onready var audio_win_level : AudioStreamPlayer = $AudioWin
onready var audio_time_over : AudioStreamPlayer = $AudioTimeOver

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

func refresh_level() -> void:
	var level_info : Dictionary = Levels.get_level()
	width = level_info.width
	height = level_info.height
	p = level_info.p
	time_max = level_info.time

func reset_score() -> void:
	score = 0
	
func reset_time() -> void:
	time_left = time_max
	
func update_score(delta : int) -> void:
	score += delta
	if score > best_score:
		best_score = score
	
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
	
func set_is_sound(value : bool) -> void:
	is_sound = value
	if is_sound:
		audio_stream_player.play(last_stream_position)
	else:
		last_stream_position = audio_stream_player.get_playback_position()
		audio_stream_player.stop()
		
func play_win_level() -> void:
	audio_win_level.is_playing = true
	
func play_time_over() -> void:
	if is_sound:
		audio_time_over.is_playing = true
