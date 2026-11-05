extends Node3D

const MONITOR_UI = preload("res://objects/monitor/monitor_ui.tscn")

func interact_notification(_percentage)->void:
	var interface = get_tree().get_first_node_in_group("interface")
	if interface:
		interface.add_child(MONITOR_UI.instantiate())
