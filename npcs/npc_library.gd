extends Node

@export var npcs:Array[String] = ["basic", "basic_2"]
@export var weights:PackedFloat32Array = [2.0, 1.0]

var rng:= RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	
func get_random() -> String:
	return npcs[rng.rand_weighted(weights)]
