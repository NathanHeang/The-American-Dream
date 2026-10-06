extends Node3D
class_name Road
@export var road_shape:String = "no_edge"
const EDGE = preload("res://models/edge.blend")

func _ready() -> void:
	var city = get_parent() as City
	var grid_pos = Vector2i(position.x/city.block_size, position.z/city.block_size)
	
	
	
	
	if city.size.x > grid_pos.y:
		var up = city.placed_city[grid_pos.x][grid_pos.y+1]
		if not up is Road:
			var edge = EDGE.instantiate() as Node3D
			edge.position = Vector3(0, 1.2, 4.85)
			add_child(edge)
	if 0 < grid_pos.y:
		var down = city.placed_city[grid_pos.x][grid_pos.y-1]
		if not down is Road:
			var edge = EDGE.instantiate() as Node3D
			edge.position = Vector3(0, 1.2, -4.85)
			add_child(edge)
	if 0 < grid_pos.y:
		var left = city.placed_city[grid_pos.x-1][grid_pos.y]
		if not left is Road:
			var edge = EDGE.instantiate() as Node3D
			edge.position = Vector3(-4.85, 1.2, 0)
			add_child(edge)
	if city.size.x > grid_pos.y:
		var right = city.placed_city[grid_pos.x+1][grid_pos.y]
		if not right is Road:
			var edge = EDGE.instantiate() as Node3D
			edge.position = Vector3(4.85, 1.2, 0)
			add_child(edge)
