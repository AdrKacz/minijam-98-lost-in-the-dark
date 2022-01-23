extends CPUParticles


var last_stream_position : float = 0
var is_sound : bool = false

onready var audio_stream_player : AudioStreamPlayer3D = $AudioStreamPlayer3D

func _process(_delta):
	if not is_sound and Global.is_sound:
		audio_stream_player.play(last_stream_position)
		is_sound = true
	elif is_sound and not Global.is_sound:
		last_stream_position = audio_stream_player.get_playback_position()
		audio_stream_player.stop()
		is_sound = false
