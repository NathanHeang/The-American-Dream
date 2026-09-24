extends Label

func _ready() -> void:
	PlayerStats.balance_changed.connect(update)

func update(_old:int, new:int)->void:
	var mins = (new / 60) % 60
	var hr = (new / 3600) % 24
	var dy = new / 86400 + 1
	text = "Day %2d - %02d:%02d" % [dy, hr, mins]
