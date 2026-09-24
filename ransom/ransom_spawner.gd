extends Button

const RANSOM = preload("res://ransom/ransom.tscn")

@onready var despawn: Timer = $Despawn

func _ready() -> void:
	position = Vector2(randi_range(0, 175), randi_range(0, 275))
	
func _on_despawn_timeout() -> void:
	queue_free()

func _on_button_down() -> void:
	var ransom := RANSOM.instantiate()
	get_parent().add_child(ransom)
	queue_free()
