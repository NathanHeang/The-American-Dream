extends StaticBody3D

@onready var shape_cast_3d: ShapeCast3D = %ShapeCast3D

func _ready() -> void:
	pass

func _process(_dt: float) -> void:
	for i in range(shape_cast_3d.get_collision_count()):
		var papers = shape_cast_3d.get_collider(i)
		if papers is Papers:
			System.money += papers.value
			papers.queue_free()
