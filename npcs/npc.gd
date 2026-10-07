extends RigidBody3D

const NPCS_PATH = "res://npcs/"

@onready var sprite: Sprite3D = $Sprite3D
@onready var path:String

func _ready() -> void:
	path = NPCLibrary.get_random()
	sprite.texture = load(NPCS_PATH.path_join(path).path_join("full.png"))
	
func interact()->void:
	print("ey")
