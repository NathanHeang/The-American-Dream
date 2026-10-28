extends Window
@onready var color_rect: ColorRect = $ColorRect
const GLITCH = preload("res://ransom/glitch.tres")

func _ready() -> void:
	match randi_range(0, 6):
		1:title="Wanna Cry?"
		2:title="Wanna Scream?"
		3:title="Wanna Shout?"
		4:title="now or never"
		5:title="i'm being generous"
		_:pass
	size = Vector2(randi_range(200, 400), randi_range(200, 400))
	position = Vector2(randi_range(0, 2050), randi_range(0, 550))
	
	if randi() % 2 == 1:
		color_rect.material = GLITCH
	if randi() % 2 == 1:
		borderless = true
	
func _on_timer_timeout() -> void:
	queue_free()
