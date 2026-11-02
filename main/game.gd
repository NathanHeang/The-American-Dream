extends Node

@onready var event_timer: Timer = %EventTimer

signal balance_changed(old, new)
signal time_changed(old, new)

var started:bool = false

var money:float = 0: #in cents
	set(new):
		var old = money
		money = new
		balance_changed.emit(old, new)
		
var time:int = 28800: #in seconds, starting at 8 am
	set(new):
		var old = time
		time = new
		time_changed.emit(old, new)
	
func _ready() -> void:
	add_to_group("game")
	start_day()
	
func _process(_dt: float) -> void:
	if started:
		time+=1

func start_day()->void:
	started = true
	event_timer.start()
	pass
	
func end_day()->void:
	started = false
	event_timer.stop()
	pass
var a = false
func _on_event() -> void:
	event_timer.wait_time = randf_range(2.0, 3.0)
	if a == false:
		a = true
		add_child(RansomWindow.new())
	pass
