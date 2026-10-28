extends Node3D
class_name City

const NPC = preload("res://npc/npc.tscn")

@export var size:Vector2i = Vector2i(7, 5)
@export var part_size:int = 10

var city:Array
signal city_generated()

func _ready() -> void:
	generate_city()
	populate_city()
	
func populate_city()->void:
	for x in size.x:
		for y in size.y:
			var part = city[x][y]
			if part is Road and randi_range(0, 1) == 1:
				var npc:RigidBody3D = NPC.instantiate()
				npc.position = Vector3(x*part_size+randf_range(-part_size/2.0, part_size/2.0), 20, y*part_size+randf_range(-part_size/2.0, part_size/2.0))
				add_child(npc)
				
func generate_city() -> void:
	for x in size.x:
		city.append([])
		for y in size.y:
			var part = CityPartLibrary.get_random().instantiate()
			city[x].append(part)
			part.position = Vector3i(x*part_size, 0, y*part_size)
			add_child(part)
	city_generated.emit()
	
func check_pos(pos:Vector2i) -> bool:
	if pos.x >= 0 && pos.x < size.x && pos.y >= 0 && pos.y < size.y:
		return true
	return false
	
func get_part(pos:Vector2i) -> CityPart:
	if check_pos(pos):
		return city[pos.x][pos.y]
	return null

func get_adjacent(pos:Vector2i) -> Dictionary:
	var dirs = {}
	var up = get_part(pos + Vector2i(0, 1))
	if up: dirs["up"] = up
	var down = get_part(pos + Vector2i(0, -1))
	if down: dirs["down"] = down
	var left = get_part(pos + Vector2i(-1, 0))
	if left: dirs["left"] = left
	var right = get_part(pos + Vector2i(1, 0))
	if right: dirs["right"] = right
	return dirs
