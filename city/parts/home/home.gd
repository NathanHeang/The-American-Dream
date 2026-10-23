extends Node3D
@onready var mesh: MeshInstance3D = $Cube

func _ready() -> void:
	var new_material = mesh.get_active_material(0).duplicate() as StandardMaterial3D
	new_material.albedo_color = Color.from_rgba8(randi_range(125, 255), randi_range(125, 255), randi_range(125,255))
	mesh.set_surface_override_material(0, new_material)
