extends Label

func _ready() -> void:
	System.time_changed.connect(time_changed)

func time_changed(_old:int, new:int)->void:
	text = System.time_string
