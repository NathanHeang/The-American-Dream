extends Control
class_name ElevatorUI

@onready var elevator:Path3D
@onready var floors:GridContainer = %Floors

func _ready() -> void:
	for button:Button in floors.get_children():
		button.button_down.connect(func ():
			elevator.call("change_floor", int(button.name))
			toggle(false)
			)

func toggle(state = null)->void:
	visible = state if state else not visible
	System.mouse_mode = Input.MOUSE_MODE_HIDDEN if visible else Input.MOUSE_MODE_CAPTURED
	var plr:Player = get_tree().get_first_node_in_group("plr")
	plr.controllable = not visible
	var interface = get_tree().get_first_node_in_group("interface")
	if interface:
		var balance_ui = interface.get_node("%Balance")
		if balance_ui:
			(balance_ui as Control).visible = not visible
