extends Control

@onready var label: Label = $PanelContainer/Label
@onready var cash_particle: CPUParticles2D = $CashParticle
@onready var coin_particle: CPUParticles2D = $CoinParticle

func _ready() -> void:
	PlayerHandler.balance_changed.connect(update)

func update(old:float, new:float)->void:
	var dollars = int(new)
	var cents = int(new*100) % 100
	label.text = "$%d.%02d" % [dollars, cents]
	
	var diff = new - old
	var diff_dollars = int(diff)
	var diff_cents = int(diff*100) % 100
	if diff_dollars > 0:
		cash_particle.amount = diff_dollars
		cash_particle.emitting = true
	if diff_cents > 0:
		coin_particle.amount = diff_cents
		coin_particle.emitting = true
	if diff < 0:
		pass
