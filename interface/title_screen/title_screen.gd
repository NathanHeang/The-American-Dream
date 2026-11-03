extends Control

@onready var music: AudioStreamPlayer = %Music
@onready var icon: TextureRect = %Icon
const shattered_logo = preload("res://generic/textures/logo3.png")

#@onready var plr:Player = get_tree().get_first_node_in_group("plr")
#@onready var cam:Camera3D = plr.get_node("%Camera3D")

var broken:bool = false

func _ready() -> void:
	music.play()
	#(cam.get_node("blue_shader") as MeshInstance3D).visible = true

func _process(_dt: float) -> void:
	if not broken and music.get_playback_position() >= 13.75:
		broken = true
		icon.texture = shattered_logo
	
func _on_quit_button_down() -> void:
	get_tree().quit()
