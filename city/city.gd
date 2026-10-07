extends Node3D
class_name City

@export var size:Vector2i = Vector2i(7, 5)
@export var block_size:int = 10

var city:Array
signal city_generated()

func _ready() -> void:
	generate_city()

func generate_city() -> void:
	for x in size.x:
		city.append([])
		for y in size.y:
			var block = CityLibrary.get_random().instantiate()
			city[x].append(block)
			block.position = Vector3i(x*block_size, 0, y*block_size)
			add_child(block)
	city_generated.emit()
	
func check_pos(pos:Vector2i) -> bool:
	if pos.x >= 0 && pos.x < size.x && pos.y >= 0 && pos.y < size.y:
		return true
	return false
	
func get_block(pos:Vector2i) -> Block:
	if check_pos(pos):
		return city[pos.x][pos.y]
	return null

func get_adjacent(pos:Vector2i) -> Dictionary:
	var dirs = {}
	var up = get_block(pos + Vector2i(0, 1))
	if up: dirs["up"] = up
	var down = get_block(pos + Vector2i(0, -1))
	if down: dirs["down"] = down
	var left = get_block(pos + Vector2i(-1, 0))
	if left: dirs["left"] = left
	var right = get_block(pos + Vector2i(1, 0))
	if right: dirs["right"] = right
	return dirs
