extends Node3D
class_name City

const WIFE = preload("res://city/parts/office/wife.tscn")
const NPC = preload("res://npcs/npc.tscn")
const OFFICE = preload("res://city/parts/office/office.tscn")
const ROAD = preload("res://city/parts/road/road.tscn")
const EMPTY = preload("res://city/parts/empty/empty.tscn")
const HOME = preload("res://city/parts/home/home.tscn")
const BUILDING = preload("res://city/parts/building/building.tscn")

@export var size:Vector2i = Vector2i(13, 7)
@export var part_size:int = 10
@export var home_pos = Vector2i(2, 2)
var city:Array
signal city_generated()

func _ready() -> void:
	add_to_group("City")
	generate_city()
	populate_city()
	
func populate_city()->void:
	var wife:Node3D = WIFE.instantiate()
	wife.global_position = Vector3i(home_pos.x*part_size+2, 4, home_pos.y*part_size+2)
	add_child(wife)
	for x in size.x:
		for y in size.y:
			if randi_range(0, 3) == 1:
				var part:CityPart = city[x][y]
				if part is Road:
					var npc:RigidBody3D = NPC.instantiate()
					npc.position = Vector3(x*part_size+randf_range(-part_size/2.0, part_size/2.0), 20, y*part_size+randf_range(-part_size/2.0, part_size/2.0))
					add_child(npc)
				
func generate_city() -> void:
	var office_pos = Vector2i(3*size.x/4, 3*size.y/4)
	for x in size.x:
		city.append([])
		for y in size.y:
			var part:CityPart
			if x == home_pos.x and y == home_pos.y:
				part = HOME.instantiate()
			elif x == office_pos.x and y == office_pos.y:
				part = OFFICE.instantiate()
			elif x > office_pos.x-4 and x < office_pos.x+4 and y > office_pos.y-2 and y < office_pos.y+2:
				part = EMPTY.instantiate()
			elif x > office_pos.x-7 and x < office_pos.x+7 and y > office_pos.y-5 and y < office_pos.y+5:
				part = ROAD.instantiate()
			elif x > size.x/2-4 and x < size.x/2+4 and y > size.y/2-4 and y < size.y/2+4:
				part = ROAD.instantiate()
			elif x == 0 or x == size.x or y == 0 or y == size.y:
				part = BUILDING.instantiate()
			elif x < 2 or x > size.x-2 or y < 2 or y > size.y-2:
				part = ROAD.instantiate()
			else:
				part = CityPartLibrary.get_random().instantiate()
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
