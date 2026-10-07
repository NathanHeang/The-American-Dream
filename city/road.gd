extends Block
class_name Road
@export var road_shape:String = "no_edge"
const EDGE = preload("res://models/edge.blend")
func _ready()->void:
	var city = get_parent() as City
	city.city_generated.connect(on_city_generated)
	
func on_city_generated() -> void:
	var city = get_parent() as City
	var pos = Vector2i(position.x/city.block_size, position.z/city.block_size)
	var adjacent = city.get_adjacent(pos)
	
	if not adjacent.has("up") or not adjacent.up is Road:
			var edge = EDGE.instantiate() as Node3D
			edge.position = Vector3(0, 1.2, 4.85)
			add_child(edge)
	if not adjacent.has("down") or not adjacent.down is Road:
			var edge = EDGE.instantiate() as Node3D
			edge.position = Vector3(0, 1.2, -4.85)
			add_child(edge)
	if not adjacent.has("left") or not adjacent.left is Road:
			var edge = EDGE.instantiate() as Node3D
			edge.position = Vector3(-4.85, 1.2, 0)
			edge.rotation_degrees = Vector3(0, 90, 0)
			add_child(edge)
	if not adjacent.has("right") or not adjacent.right is Road:
			var edge = EDGE.instantiate() as Node3D
			edge.position = Vector3(4.85, 1.2, 0)
			edge.rotation_degrees = Vector3(0, 90, 0)
			add_child(edge)
