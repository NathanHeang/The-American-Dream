extends Node3D

func interact_notification(_percentage)->void:
	var interface = get_tree().get_first_node_in_group("interface")
	if interface:
		var ui:ComputerUI = interface.get_node("%Computer")
		if ui and not System.is_in_menu:
			ui.toggle(true)
