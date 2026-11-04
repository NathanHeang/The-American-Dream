extends Path3D

@onready var anim_plr: AnimationPlayer = %AnimationPlayer
@onready var ui: Control = %ElevatorUI

func _ready() -> void:

	pass
	
func change_floor() -> void:
	curve.set_point_position(1, Vector3(0, 15, 0))
	anim_plr.play("move")

func interact_notification(_percentage:float)->void:
	change_floor()
