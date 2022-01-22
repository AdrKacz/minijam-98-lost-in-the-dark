extends Spatial

signal controller_touch_it

func _on_Area_body_entered(body):
	if body.is_in_group('controller'):
		print('Touch it!')
		emit_signal("controller_touch_it")
