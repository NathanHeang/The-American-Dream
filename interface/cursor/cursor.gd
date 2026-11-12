extends Control
@onready var highlight_reticle: TextureRect = %HighlightReticle
@onready var interacting_reticle: TextureRect = %InteractingReticle
@onready var interaction_label: Label = %InteractionLabel
var found_plr = false
var plr:Player

func _process(dt: float) -> void:
	if not found_plr:
		plr = get_tree().get_first_node_in_group("plr")
		if plr:
			found_plr = true
			plr.interaction_controller.focused.connect(func(description:String)->void:
				interaction_label.text = description
				interaction_label.visible = true
				highlight_reticle.visible = true
			)
			plr.interaction_controller.unfocused.connect(func ()->void:
				highlight_reticle.visible = false
				interaction_label.visible = false
			)
			#plr.interaction_controller.interacted.connect(func(description:String)->void:
			#	interacting_reticle.visible = true
			#)
			#plr.interaction_controller.stopped_interacting.connect(func ()->void:
			#	interacting_reticle.visible = false
			#)
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		global_position = lerp(global_position, get_viewport_rect().size/2, 16.5*dt)
	else:
		global_position = lerp(global_position, get_global_mouse_position(), 16.5*dt)
