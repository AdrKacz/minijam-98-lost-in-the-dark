extends Camera


func _process(delta) -> void:
	var input_mouvement_vector : Vector2 = Vector2()
	
	if Input.is_action_pressed("ui_up"):
		input_mouvement_vector.y += 1
	if Input.is_action_pressed("ui_down"):
		input_mouvement_vector.y -= 1
	if Input.is_action_pressed("ui_right"):
		input_mouvement_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_mouvement_vector.x -= 1
	
	input_mouvement_vector = input_mouvement_vector.normalized()
	
	var dir : Vector3 = Vector3()
	dir += global_transform.basis.z * input_mouvement_vector.y
	dir += global_transform.basis.x * input_mouvement_vector.x
	dir = dir.normalized()
	
	
