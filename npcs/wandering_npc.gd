extends RigidBody3D
class_name Random_NPC

@onready var change_direction: Timer = $ChangeDirection

const path := "res://npcs/textures/"
@export var blacklist:Array[String] = [
	"boss.png",
	"wife.png"
]

@onready var sprite: Sprite3D = $Sprite3D

func choose_random()->void:
	var files:PackedStringArray = DirAccess.get_files_at(path)
	var texture_name:String = files[files.size() * randf()]
	if ".import" in texture_name or texture_name in blacklist:
		choose_random()
	else:
		sprite.texture = load("%s/%s" % [path, texture_name])

func _ready() -> void:
	choose_random()
	
func _on_change_direction_timeout() -> void:
	change_direction.wait_time = randf_range(1, 10)
	linear_velocity = Vector3(randf_range(-4, 4), 0, randf_range(-4, 4))
