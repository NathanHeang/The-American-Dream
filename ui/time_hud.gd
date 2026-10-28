extends Label

func _ready() -> void:
	PlayerHandler.time_changed.connect(update)

func update(_old:float, new:float)->void:
	var mins = int(new / 60) % 60
	var hr = int(new / 3600) % 24
	var dy = new / 86400 + 1
	text = "Day %2d - %02d:%02d" % [dy, hr, mins]
