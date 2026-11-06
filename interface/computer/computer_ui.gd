extends Control
class_name ComputerUI

@onready var editor: VBoxContainer = %Editor
@onready var mail: VBoxContainer = %Mail
@onready var monitor: Node3D

func toggle(state = null)->void:
	visible = state if state else not visible
	System.mouse_mode = Input.MOUSE_MODE_HIDDEN if visible else Input.MOUSE_MODE_CAPTURED
	var plr:Player = get_tree().get_first_node_in_group("plr")
	plr.controllable = not visible
	var interface = get_tree().get_first_node_in_group("interface")
	if interface:
		var ui = interface.get_node("%Balance")
		if ui:
			(ui as Control).visible = not visible
	
func _on_editor_button_down() -> void:
	editor.visible = true
	mail.visible = false

func _on_mail_button_down() -> void:
	editor.visible = false
	mail.visible = true
