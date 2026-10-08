extends Dialogue
class_name DialogueText

@export var speaker_name:String
@export var speaker_texture:Texture

@export_multiline var text:String
@export_range(0.1, 30.0, 0.1) var text_speed:float = 20.0

@export var text_sound:AudioStream
@export var text_volume:int=1
@export var text_min_pitch:float=.85
@export var text_max_pitch:float=1.15
