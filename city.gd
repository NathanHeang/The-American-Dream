extends Node3D

@export var size:Vector2i = Vector2i(7, 5)
var start:Vector2i = Vector2i(randi_range(0, size.x -1), randi_range(0, size.y -1))
var city:Array
@onready var block_scenes:Dictionary[String, PackedScene]

func register_block_scenes():
	var path = "res://blocks/"
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if file_name.get_extension() == "tscn":
					var full_path = path.path_join(file_name)
					block_scenes[file_name] = load(full_path)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
		get_tree().quit()
	print(block_scenes)

func _ready() -> void:
	register_block_scenes()
	generate_city()
	print_city()

func generate_city() -> void:
	for x in size.x:
		city.append([])
		for y in size.y:
			city[x].append(0)

func place_city() -> void:
	for x in size.x:
		for y in size.y:
			var block_id = city[x][y]
			var block_scene:PackedScene = block_scenes.get(block_id)
			

func print_city() -> void:
	var string:String= ""
	for y in range(size.y - 1, -1, -1):
		for x in size.x:
			string += "[" + str(city[x][y]) + "]"
		string += "\n"
	print(string)
