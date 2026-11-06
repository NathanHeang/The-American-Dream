extends Control

@onready var title_screen_music: AudioStreamPlayer = %TitleScreenMusic
@onready var guide_music: AudioStreamPlayer = %GuideMusic
@onready var icon: TextureRect = %Icon
const shattered_logo = preload("res://generic/textures/logo3.png")
@onready var title_screen: Control = $InnerBackground/TitleScreen
@onready var guide: Control = $InnerBackground/Guide

var broken:bool = false

func _ready() -> void:
	title_screen_music.play()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
func _process(_dt: float) -> void:
	if not broken and title_screen_music.get_playback_position() >= 13.75:
		broken = true
		icon.texture = shattered_logo
	
func _on_play_button_down() -> void:
	System.transition()
	System.transition_midpoint.connect(func():
		title_screen.visible = false
		guide.visible = true
		title_screen_music.stop()
		guide_music.play()
		, 4)
		
func _on_back_button_down() -> void:
	System.transition()
	System.transition_midpoint.connect(func():
		title_screen.visible = true
		guide.visible = false
		title_screen_music.play()
		guide_music.stop()
		, 4)
	
func _on_continue_button_down() -> void:
	System.transition()
	System.transition_midpoint.connect(play, 4)

func play()->void:
	get_tree().change_scene_to_file("res://main/root.tscn")
	System.start_day()

func _on_quit_button_down() -> void:
	get_tree().quit()
