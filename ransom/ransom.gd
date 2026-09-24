extends Window
class_name RansomWindow

const RANDOM_POPUP = preload("res://ransom/random_popup.tscn")
const STOP = preload("res://ransom/stop.tscn")

@onready var timer_music: AudioStreamPlayer = $AudioStreamPlayer
@onready var ransom_timer: Timer = $RansomTimer
@onready var time_label: Label = $Panel/Panel3/Time
@export var price: float = 205.89
@onready var price_label: Label = $Panel/Panel2/Price

func _ready() -> void:
	timer_music.play()
	randomize_position()
	
func _process(delta: float) -> void:
	var minutes = int(ransom_timer.time_left/60)
	var sec = int(ransom_timer.time_left) % 60
	time_label.text = "%02d:%02d" % [minutes, sec]
	var dollars = int(price)
	var cents = int(price*100) % 100
	price_label.text = "$%d.%02d" % [dollars, cents]

	
func spawn_popup() -> void:
	get_parent().add_child(RANDOM_POPUP.instantiate())

func randomize_position() -> void:
	position = Vector2(randi_range(0, 1050), randi_range(0, 550))

func timeout() -> void:
	OS.alert("Something unexpected happened! Please restart your device and try again.")
	
func _on_close_requested() -> void:
	if PlayerStats.money >= price:
		pay_ransom()
	else:
		get_parent().add_child(STOP.instantiate())
		
func pay_ransom() -> void:
	PlayerStats.money -= price
	queue_free()
