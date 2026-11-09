extends Path3D

@onready var anim_plr: AnimationPlayer = %AnimationPlayer

func change_floor(pos:int) -> void:
	curve.set_point_position(1, Vector3(0, pos*15, 0))
	anim_plr.play("move")

func interact_notification(_percentage:float)->void:
	var interface = get_tree().get_first_node_in_group("interface")
	if interface:
		var ui:ElevatorUI = interface.get_node("%Elevator")
		if ui and not System.is_in_menu:
			ui.elevator = self
			ui.toggle(true)
