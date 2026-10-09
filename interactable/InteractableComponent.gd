extends Node
class_name InteractableComponent

var plrs_hovering = {}

signal interacted()

func interact():
	interacted.emit()
	
func hover_cursor(plr:CharacterBody3D):
	plrs_hovering[plr] = Engine.get_process_frames()
	
func get_hovering_plr()->CharacterBody3D:
	for plr in plrs_hovering.keys():
		var cam = get_viewport().get_camera_3d() if get_viewport() else null
		if cam in plr.find_children("*", Camera3D):
			return plr
	return null

func _process(_dt: float) -> void:
	for plr in plrs_hovering.keys():
		if Engine.get_process_frames() - plrs_hovering[plr] > 1:
			plrs_hovering.erase(plr)
