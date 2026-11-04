extends Decal
class_name Poster

const path := "res://posters"

func choose_random()->void:
	var files:PackedStringArray = DirAccess.get_files_at(path)
	var texture_name:String = files[files.size() * randf()]
	if ".import" in texture_name or ".gd" in texture_name:
		choose_random()
	else:
		texture_albedo = load("%s/%s" % [path, texture_name])

func _ready() -> void:
	size = Vector3(randf_range(.5, 2), randf_range(.5, 2), randf_range(.5, 2))
	rotation_degrees = Vector3(randi_range(0, 3)*90, randi_range(0, 3)*90, randi_range(0, 3)*90)
	choose_random()
