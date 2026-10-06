extends Node3D
class_name City

@export var size:Vector2i = Vector2i(7, 5)
@export var block_size:int = 10
@export var debug:bool = false
var city:Array
var placed_city:Array
@onready var block_scenes:Dictionary[String, PackedScene]
const BLOCK_DEBUG_LABEL = preload("res://city/block_debug_label.tscn")
signal city_placed()

func register_block_scenes():
	var path = "res://city/blocks/"
	var dir:DirAccess = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name:String = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if file_name.get_extension() == "tscn":
					var full_path:String = path.path_join(file_name)
					block_scenes[file_name.trim_suffix(".tscn")] = load(full_path)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
		get_tree().quit()
	if debug:
		print("Loaded blocks:")
		print(block_scenes)

func _ready() -> void:
	register_block_scenes()
	generate_city()
	if debug:
		print_city()
	place_city()

func generate_city() -> void:
	for x in size.x:
		city.append([])
		placed_city.append([])
		for y in size.y:
			city[x].append("road" if randi_range(0, 1) == 1 else "building")
			placed_city[x].append(0)
	city[size.y/2][size.y/2] = "home"

func place_city() -> void:
	for x in size.x:
		for y in size.y:
			var block_id = str(city[x][y])
			var block_scene:PackedScene = block_scenes.get(block_id)
			if not block_scene:
				print("Scene not found: " + block_id)
				continue
			var block:Node3D = block_scene.instantiate()
			block.position = Vector3i(x*block_size, 0, y*block_size)
			add_child(block)
			placed_city[x][y] = block
			if debug:
				var label:Label3D = BLOCK_DEBUG_LABEL.instantiate()
				label.text = block_id
				block.add_child(label)
	city_placed.emit()

func print_city() -> void:
	var string:String= ""
	for y in range(size.y - 1, -1, -1):
		for x in size.x:
			string += "[" + str(city[x][y]) + "]"
		string += "\n"
	print(string)
	
func check_pos(pos:Vector2i) -> bool:
	if pos.x >= 0 && pos.x < size.x && pos.y >= 0 && pos.y < size.y:
		return true
	return false
	
func get_block(pos:Vector2i) -> Block:
	if check_pos(pos):
		return placed_city[pos.x][pos.y]
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
