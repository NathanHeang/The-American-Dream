extends ColorRect
class_name Transition

@onready var anim_plr: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	anim_plr.play("start")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "start":
		anim_plr.play("end")
	else:
		queue_free()
