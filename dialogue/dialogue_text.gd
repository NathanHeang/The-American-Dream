extends Dialogue
class_name DialogueText

@export var speaker_name:String
@export var speaker_texture:Texture
@export var speaker_hframes:int=1
@export var speaker_rest_frame:int=0

@export_multiline var text:String
@export_range(0.1, 30.0, 0.1) var text_speed:float = 1.0

@export var text_sound:AudioStream
@export var text_volume:int
@export var text_min_pitch:float=.85
@export var text_max_pitch:float=1.15

@export var cam_pos:Vector2=Vector2(999.999, 999.999)
@export_range(0.05, 10.0, 0.05) var cam_transition_time:float= 1.0
