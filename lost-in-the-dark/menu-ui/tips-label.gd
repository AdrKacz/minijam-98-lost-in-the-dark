extends Label


export (Array, String) var tips : Array = []

func _ready():
	if Global.score >=0:
		random_tips()
	else:
		hide()
		
func random_tips() -> void:
	if Global.score < 5:
		text = 'Follow the green light...'
	else:
		text = tips[randi() % tips.size()]
