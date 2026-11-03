extends Control

func _process(dt: float) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		global_position = lerp(global_position, get_viewport_rect().size/2, 16.5*dt)
	else:
		global_position = lerp(global_position, get_global_mouse_position(), 16.5*dt)
