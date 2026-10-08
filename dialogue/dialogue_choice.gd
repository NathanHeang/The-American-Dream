extends Dialogue
class_name DialogueChoice

@export var speaker_name:String
@export var speaker_texture:Texture
@export var speaker_hframes:int=1
@export var speaker_select_frame:int=0

@export_multiline var text:String

@export var choice_text: Array[String]
@export var choice_function_call: Array[DialogueFunction]
