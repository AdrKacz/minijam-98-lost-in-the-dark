extends Control

signal hit_focus

export (float, 10, 60) var time_level : float = 30

var score : int = 0
var time_spent : float = 0

onready var time_label : Label = $TimeMarginContainer/TimeContainer/TimeLabel
onready var score_label : Label = $ScoreMarginContainer/ScoreContainer/ScoreLabel

onready var return_menu_center : MarginContainer = $ReturnMenuMarginContainer
onready var focus_center : CenterContainer = $FocusCenterContainer

onready var sound_off_container : MarginContainer = $SoundOffMarginContainer
onready var sound_on_container : MarginContainer = $SoundOnMarginContainer
	
	
func display_time():
	time_label.text = "%06.3f" % (Global.get_time_left())
	
func display_score():
	score_label.text = "%02d" % Global.score

func _ready():
	display_sound_container()
	display_time()
	display_score()
	
func _process(_delta):
	display_time()
	if not focus_center.is_visible_in_tree() and Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		focus_center.show()
		return_menu_center.show()
	elif focus_center.is_visible_in_tree() and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		focus_center.hide()
		return_menu_center.hide()

func _on_FocusButton_pressed():
	emit_signal("hit_focus")


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


func _on_MainMenuButton_pressed():
	Global.load_menu_scene()
