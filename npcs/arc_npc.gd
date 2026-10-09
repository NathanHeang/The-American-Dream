extends RigidBody3D

@onready var sprite: Sprite3D = $Sprite3D

func _on_interactable_component_interacted() -> void:
	(Hud.get_node("DialogueHandler") as DialogueHandler).begin("test")
	PlayerHandler.money = 99999
