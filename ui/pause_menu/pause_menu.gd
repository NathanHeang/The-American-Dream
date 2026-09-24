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
