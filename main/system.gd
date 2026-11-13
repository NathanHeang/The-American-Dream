extends Node

signal balance_changed(old, new)
signal time_changed(old, new)
signal transition_midpoint()

const TRANSITION = preload("res://transitions/transition.tscn")
const END_SCREEN = preload("res://interface/end_screen/end_screen.tscn")

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
		
var day:int = 16

var time_string:String:
	get():
		var mins = int(time / 60) % 60
		var hr = int(time / 3600) % 24
		return "November %2d - %02d:%02d" % [day, hr if hr <= 12 else hr-12, mins]
		
var mouse_mode:Input.MouseMode = Input.MOUSE_MODE_HIDDEN:
	set(new):
		mouse_mode = new
		if !get_tree().paused:
			Input.mouse_mode = new
			
var is_in_menu:bool:
	get():
		var interface = get_tree().get_first_node_in_group("interface")
		if interface:
			for ui:Control in interface.get_node("%Menus").get_children():
				if ui.visible == true:
					return true
		return false
		
@onready var event_timer: Timer = %EventTimer

var started:bool = false
var required_money:float = randi_range(150, 300)

func _process(dt: float) -> void:
	if started:
		time+=max(dt, 1)
		if time >= 61200:
			end_day()

func start_day()->void:
	day+=1
	time = 28800
	started = true
	event_timer.start()
	
func end_day()->void:
	started = false
	event_timer.stop()
	transition()
	transition_midpoint.connect(func():
		get_tree().change_scene_to_file("res://interface/end_screen/end_screen.tscn")
		, 4)
	
func transition()->void:
	var new_transition:Transition = TRANSITION.instantiate()
	add_child(new_transition)
	new_transition.anim_plr.animation_finished.connect(transition_changed, 4)
	
func transition_changed(anim_name)->void:
	if anim_name == "start":
		transition_midpoint.emit()

var a = false
func _on_event() -> void:
	event_timer.wait_time = randf_range(2.0, 3.0)
	if a == false:
		a = true
