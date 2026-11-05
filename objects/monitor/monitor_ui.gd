extends Control

@onready var editor: VBoxContainer = %Editor
@onready var mail: VBoxContainer = %Mail
@onready var monitor: Node3D

func _ready() -> void:
	print("a")
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
func _on_editor_button_down() -> void:
	editor.visible = true
	mail.visible = false

func _on_mail_button_down() -> void:
	editor.visible = false
	mail.visible = true

func _on_power_button_down() -> void:
	Input.mouse_mode = System.mouse_mode
	queue_free()
