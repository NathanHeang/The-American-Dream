extends Window
class_name RansomWindow

const RANDOM_POPUP = preload("res://ransom/random_popup.tscn")
const STOP = preload("res://ransom/stop.tscn")
const FACE_2 = preload("res://ransom/face2.png")

@onready var timer_music: AudioStreamPlayer = $Music
@onready var time_label: Label = $Panel/Panel3/Time
@export var price: float = 205.89
@onready var price_label: Button = $Panel/Panel2/Price
@onready var face: TextureRect = %Face

func _ready() -> void:
	randomize_position()
	get_tree().set_auto_accept_quit(false)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var cam:Camera3D = get_tree().get_current_scene().find_child("Camera3D", true, false)
	if cam:
		var shader:MeshInstance3D = cam.get_node_or_null("red_shader")
		if shader:
			shader.visible = true
	
func _process(_dt: float) -> void:
	var time_left = timer_music.stream.get_length() - timer_music.get_playback_position()
	var minutes = int(time_left/60)
	var sec = int(time_left) % 60
	time_label.text = "%02d:%02d" % [minutes, sec]
	var dollars = int(price)
	var cents = int(price*100) % 100
	price_label.text = "$%d.%02d" % [dollars, cents]

func spawn_popup() -> void:
	for i in range(3):
		get_parent().add_child(RANDOM_POPUP.instantiate())

func randomize_position() -> void:
	position = Vector2(randi_range(0, 2050), randi_range(0, 550))

func timeout() -> void:
	face.texture = FACE_2
	#OS.alert("Something unexpected happened! Please restart your device and try again.")
	get_tree().quit(66)
		
func pay_ransom() -> void:
	PlayerHandler.money -= price
	queue_free()

func attempt_payment() -> void:
	if PlayerHandler.money >= price:
		pay_ransom()
		get_tree().set_auto_accept_quit(true)
		var cam:Camera3D = get_tree().get_current_scene().find_child("Camera3D", true, false)
		if cam:
			var shader:MeshInstance3D = cam.get_node_or_null("red_shader")
			if shader:
				shader.visible = false
	else:
		#get_parent().add_child(STOP.instantiate())
		OS.alert("Insufficient Funds!")
