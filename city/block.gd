extends Node3D
class_name Block

@export var random_rotation:bool = false
func _ready() -> void:
	rotation_degrees = Vector3(0, randi_range(0, 3)*90, 0)
