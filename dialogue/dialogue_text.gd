extends DialoguePart
class_name DialogueText

@export_multiline var text:String
@export_range(0.1, 30.0, 0.1) var text_speed:float = 20.0

@export var text_sound:AudioStream
@export var text_volume:float=1
@export var text_min_pitch:float=.85
@export var text_max_pitch:float=1.15
