extends AudioStreamPlayer

export (int, 3, 10) var count_down_from : int = 10
export (int, 1, 5) var count_down_to : int = 1

export (Array, AudioStream) var count_downs : Array = []
export (AudioStream) var hurry_up : AudioStream

var has_played_hurry_up : bool = false
var last_played_count_down : int = count_down_from + 1


func play_count_down(i : int) -> void:
	print("Count down to: ", i)
	if i >= count_down_to and i <= count_down_from:
		last_played_count_down = i
		stream = count_downs[i - count_down_to]
		if Global.is_sound:
			play()
	
func play_hurry_up() -> void:
	has_played_hurry_up = true
	if hurry_up:
		stream = hurry_up
		if Global.is_sound:
			play()
			
func _process(_delta):
	if Global.time_left > 14 and Global.time_left < 15 and not has_played_hurry_up:
		play_hurry_up()
	if Global.time_left < last_played_count_down - 1:
		play_count_down(int(ceil(Global.time_left)))
