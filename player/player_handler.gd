extends Node

signal balance_changed(old, new)
signal time_changed(old, new)

var money:float = 0: #in cents
	set(new):
		var old = money
		money = new
		balance_changed.emit(old, new)
		
var time:int = 28800: #in seconds
	set(new):
		var old = time
		time = new
		time_changed.emit(old, new)

func _ready() -> void:
	pass

func _process(_dt: float) -> void:
	time+=1
	money+=1
