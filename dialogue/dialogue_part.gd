extends Resource
class_name DialoguePart

@export var speaker_name:String
@export var speaker_textures:Array[Texture]
var current_texture_id:int=0

func get_current_texture()->Texture:
	var current_texture = speaker_textures[current_texture_id]
	current_texture_id+=1
	if current_texture_id >= speaker_textures.size():
		current_texture_id=0
	return current_texture
