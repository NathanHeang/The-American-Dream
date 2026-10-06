extends Block
class_name Road
@export var road_shape:String = "no_edge"
const EDGE = preload("res://models/edge.blend")
func _ready()->void:
	var city = get_parent() as City
	city.city_placed.connect(city_placed)
	
func city_placed() -> void:
	var city = get_parent() as City
	var pos = Vector2i(position.x/city.block_size, position.z/city.block_size)
	var adjacent = city.get_adjacent(pos)
	
	if adjacent.has("up"):
		if not adjacent.up is Road:
			var edge = EDGE.instantiate() as Node3D
			edge.position = Vector3(0, 1.2, 4.85)
			add_child(edge)
	if adjacent.has("down"):
		if not adjacent.down is Road:
			var edge = EDGE.instantiate() as Node3D
			edge.position = Vector3(0, 1.2, -4.85)
			add_child(edge)
	if adjacent.has("left"):
		if not adjacent.left is Road:
			var edge = EDGE.instantiate() as Node3D
			edge.position = Vector3(-4.85, 1.2, 0)
			edge.rotation_degrees = Vector3(0, 90, 0)
			add_child(edge)
	if adjacent.has("right"):
		if not adjacent.right is Road:
			var edge = EDGE.instantiate() as Node3D
			edge.position = Vector3(4.85, 1.2, 0)
			edge.rotation_degrees = Vector3(0, 90, 0)
			add_child(edge)
