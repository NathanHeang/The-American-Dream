extends Control

@onready var label: Label = $PanelContainer/Label

func _ready() -> void:
	PlayerStats.balance_changed.connect(update)

func update(_old:float, new:float)->void:
	var dollars = int(new)
	var cents = int(new*100) % 100
	label.text = "$%d.%02d" % [dollars, cents]
