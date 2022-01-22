extends Control

export (float, 10, 60) var time_level : float = 30

var score : int = 0
var time_spent : float = 0

onready var time_label : Label = $TimeMarginContainer/TimeContainer/TimeLabel
onready var score_label : Label = $ScoreMarginContainer/ScoreContainer/ScoreLabel
	
func display_time():
	time_label.text = "%06.3f" % (time_level - time_spent)
	
func display_score():
	score_label.text = "%02d" % score

func _ready():
	display_time()
	display_score()
	
func _process(delta):
	time_spent += delta
	display_time()
	
func update_score(delta):
	score += delta
	display_score()
	
func reset_time():
	time_spent = 0
