extends Window
@onready var color_rect: ColorRect = $ColorRect
const GLITCH = preload("res://ransom/glitch.tres")

func _ready() -> void:
	size = Vector2(randi_range(200, 400), randi_range(200, 400))
	position = Vector2(randi_range(0, 1050), randi_range(0, 550))
	if randi() % 2 == 1:
		color_rect.material = GLITCH
	
func _on_timer_timeout() -> void:
	queue_free()
