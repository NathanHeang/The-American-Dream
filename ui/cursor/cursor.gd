extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
func _process(_dt: float) -> void:
	position = get_global_mouse_position()

func interact_hovered(interactable:Node3D)->void:
	print(interactable.name)
