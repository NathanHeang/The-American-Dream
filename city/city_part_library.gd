extends Node

@export var scenes:Array[PackedScene] = []
@export var weights:PackedFloat32Array = []

var rng:= RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	
func get_random() -> PackedScene:
	return scenes[rng.rand_weighted(weights)]
