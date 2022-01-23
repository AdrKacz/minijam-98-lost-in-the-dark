extends Control

onready var last_score_label : Label = $ScoreMarginContainer/VBoxContainer/LastScoreCenterContainer/LastScoreLabel
onready var best_score_label : Label = $ScoreMarginContainer/VBoxContainer/BestScoreCenterContainer/BestScoreLabel

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Write last score
	if Global.score >= 0:
		var custom_text : String
		if Global.score < Global.best_score:
			custom_text = "Not your best day."
		elif Global.score < 10:
			custom_text = "I'm sure you can do better!"
		else:
			custom_text = "You nailed it!"
		last_score_label.text = "You just scored %d. %s" % [Global.score, custom_text]
	
	# Write best score
	var custom_text : String
	if Global.best_score == 0:
		custom_text = "You've not even started!"
	elif Global.best_score < 5:
		custom_text = "Good start!"
	elif Global.best_score < 20:
		custom_text = "Great job!"
	elif Global.best_score < 100:
		custom_text = "Wow! Will you reach 100?"
	else:
		custom_text = "You escaped from the darkness."
	best_score_label.text = "Your best is %d. %s" % [Global.best_score, custom_text]

func _on_StartButton_pressed():
	# TODO: If a seed is given, use the seed instead
	Global.randomize_random_number_generator()
	# Reset Time and Score
	Global.reset_score()
	Global.reset_time()
	# Load game scene
	Global.load_game_scene()
