extends NPC
class_name Random_NPC

const NPCS_PATH = "res://npcs/"

@onready var sprite: Sprite3D = $Sprite3D
@onready var path:String

func _ready() -> void:
	path = NPCLibrary.get_random()
	sprite.texture = load(NPCS_PATH.path_join(path).path_join("full.png"))
