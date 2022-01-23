extends Control

onready var last_score_label : Label = $ScoreMarginContainer/VBoxContainer/LastScoreCenterContainer/LastScoreLabel
onready var best_score_label : Label = $ScoreMarginContainer/VBoxContainer/BestScoreCenterContainer/BestScoreLabel

onready var sound_off_container : MarginContainer = $SoundOffMarginContainer
onready var sound_on_container : MarginContainer = $SoundOnMarginContainer

func _ready():
	display_sound_container()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Write last score
	if Global.score >= 0:
		var custom_text : String
		if Global.score < Global.best_score and randf() < 0.5:
			custom_text = "You've done better."
		elif Global.score < 5:
			custom_text = "I'm sure you can do better!"
		elif Global.score < 25:
			custom_text = "Do you feel how it's growing?"
		elif Global.score < 35:
			custom_text = "Halfway to the end!"
		elif Global.score < 50:
			custom_text = "You're fast, but not enough!"
		else:
			custom_text = "You nailed it!"
		last_score_label.text = "You just scored %d. %s" % [Global.score, custom_text]
	
	# Write best score
	var custom_text : String
	if Global.best_score == 0:
		custom_text = "You've not even started!"
	elif Global.best_score < 5:
		custom_text = "Good start!"
	elif Global.best_score < 15:
		custom_text = "Fire isn't at reach anymore."
	elif Global.best_score < 30:
		custom_text = "You went far!"
	elif Global.best_score < 40:
		custom_text = "I'm impressed!"
	elif Global.best_score < 50:
		custom_text = "You're faster than light!"
	elif Global.best_score < 100:
		custom_text = "Wow! Will you keep the pace to 100?"
	else:
		custom_text = "You escaped from the darkness."
	best_score_label.text = "Your best is %d. %s" % [Global.best_score, custom_text]

func _on_StartButton_pressed():
	# TODO: If a seed is given, use the seed instead
	Global.randomize_random_number_generator()
	# Refresh level
	Global.reset_score()
	Global.refresh_level()
	# Reset Time
	Global.reset_time()
	# Load game scene
	Global.load_game_scene()

func display_sound_container() -> void:
	if Global.is_sound:
		sound_off_container.hide()
		sound_on_container.show()
	else:
		sound_on_container.hide()
		sound_off_container.show()

func _on_SoundOffButton_pressed() -> void:
	Global.set_is_sound(true)
	display_sound_container()


func _on_SoundOnButton_pressed() -> void:
	Global.set_is_sound(false)
	display_sound_container()
