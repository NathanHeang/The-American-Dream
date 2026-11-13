extends Path3D
class_name Elevator
@onready var anim_plr: AnimationPlayer = %AnimationPlayer
var moving = false

func change_floor(pos:int) -> void:
	anim_plr.play("floor_"+str(pos))
	moving = true

func interact_notification(_percentage:float)->void:
	var interface = get_tree().get_first_node_in_group("interface")
	if interface:
		var ui:ElevatorUI = interface.get_node("%Elevator")
		if ui and not System.is_in_menu:
			ui.elevator = self
			ui.toggle(true)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	moving = false
