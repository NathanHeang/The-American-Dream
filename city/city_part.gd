extends Node3D
class_name CityPart

@export var enabled:bool = true
@export var weight:float = 1.0

@export var random_rotation:bool = false

func _ready() -> void:
	rotation_degrees = Vector3(0, randi_range(0, 3)*90, 0)
