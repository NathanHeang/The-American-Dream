extends Control

@onready var title: Label = %Title
@onready var message: Label = %Message
@onready var title_screen_music: AudioStreamPlayer = %TitleScreenMusic

func _ready()->void:
	title.text = "END OF DAY "+ str(System.time / 86400 + 1)
	if System.money < System.required_money:
		message.text = "You didn't earn enough money..."
	else:
		message.text = "You earned enough money to survive the day!"
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
func _on_return_button_down() -> void:
	System.transition()
	System.transition_midpoint.connect(func():
		get_tree().change_scene_to_file("res://interface/main_menu/main_menu.tscn"), 4)
