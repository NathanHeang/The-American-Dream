extends Node3D
class_name CityPart

@export var enabled:bool = true
@export var weight:float = 1.0

@export var random_rotation:bool = false
@export var min_posters:int=0
@export var max_posters:int=4

func _ready() -> void:
	if random_rotation:
		rotation_degrees = Vector3(0, randi_range(0, 3)*90, 0)
	for i in range(min_posters, max_posters):
		if randi_range(0, 5) == 0:
			var poster = Poster.new()
			poster.position = Vector3(randf_range(-4, 4), randf_range(0, 4), randf_range(-4, 4))
			#add_child(poster)
