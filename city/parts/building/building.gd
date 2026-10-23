extends StaticBody3D

const WINDOW_FLOOR = preload("res://city/parts/building/window_floor.blend")

@onready var bottom_floor: Node3D = $bottom_floor
@onready var top_floor: Node3D = $top_floor
@onready var hitbox: CollisionShape3D = $hitbox

func _ready() -> void:
	var window_floors = randi_range(0, 12)
	for i in window_floors:
		var new_floor = WINDOW_FLOOR.instantiate()
		new_floor.position = Vector3(0, (i+2)*2, 0)
		add_child(new_floor)
	top_floor.position = Vector3(0, (window_floors+2)*2, 0)
	var shape = BoxShape3D.new()
	shape.size = Vector3(10, (window_floors+3)*2, 10)
	hitbox.shape = shape
	hitbox.position = Vector3(0, (window_floors+2), 0)
