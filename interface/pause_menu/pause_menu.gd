extends CanvasLayer

func _ready() -> void:
	toggle()

func _process(_dt:float) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle()
		
func toggle()->void:
	visible = not visible
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if visible else Input.MOUSE_MODE_CAPTURED
	get_tree().paused = visible
	
func _on_resume_button_down() -> void:
	toggle()
	
func _on_quit_button_down() -> void:
	get_tree().quit()

func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, value)

func _on_resolution_selected(id: int) -> void:
	match id:
		0:DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:DisplayServer.window_set_size(Vector2i(1600, 900))
		2:DisplayServer.window_set_size(Vector2i(1280, 720))
