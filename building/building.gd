extends StaticBody3D

@onready var bottom_floor: Node3D = $bottom_floor
@onready var top_floor: Node3D = $top_floor
const WINDOW_FLOOR = preload("res://models/window_floor.blend")
@onready var hitbox: CollisionShape3D = $hitbox

func _ready() -> void:
	rotation = Vector3(0, deg_to_rad(randi_range(0, 3)*90), 0)
	var floors = randi_range(1, 12)
	for i in floors:
		var new_floor = WINDOW_FLOOR.instantiate()
		new_floor.position = Vector3(0, (i+2)*2, 0)
		add_child(new_floor)
	top_floor.position = Vector3(0, (floors+2)*2, 0)
	(hitbox.shape as BoxShape3D).size = Vector3(10, (floors+3)*2.5, 10)
	hitbox.position = Vector3(0, (floors+3)-.75, 0)
