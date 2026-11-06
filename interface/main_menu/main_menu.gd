extends Control

@onready var music: AudioStreamPlayer = %Music
@onready var icon: TextureRect = %Icon
const shattered_logo = preload("res://generic/textures/logo3.png")

var broken:bool = false

func _ready() -> void:
	music.play()
	
func _process(_dt: float) -> void:
	if not broken and music.get_playback_position() >= 13.75:
		broken = true
		icon.texture = shattered_logo
	
func _on_play_button_down() -> void:
	get_tree().change_scene_to_file("res://main/root.tscn")
	System.start_day()

func _on_quit_button_down() -> void:
	get_tree().quit()
