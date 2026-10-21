extends Node
@onready var cam: Camera3D = %Camera3D
@onready var interact_cast: RayCast3D = %InteractCast
@onready var hand: Marker3D = %Hand

var current_obj:Object
var last_potential_obj:Object
var interaction_component:InteractionComponent

func _process(_dt:float)->void:
	if current_obj:
		if not interaction_component: return
		if Input.is_action_pressed("secondary"):
			interaction_component.aux_interact()
			current_obj = null
		elif Input.is_action_pressed("primary"):
			interaction_component.interact()
		else:
			interaction_component.post_interact()
			current_obj = null
	else:
		var potential_obj:Node = interact_cast.get_collider()
		if potential_obj:
			interaction_component = potential_obj.get_node_or_null("InteractionComponent")
			if interaction_component:
				if interaction_component.can_interact == false:
					return
					
				last_potential_obj = potential_obj
				
				if Input.is_action_pressed("primary"):
					current_obj = potential_obj
					interaction_component.pre_interact(hand)
					
					if interaction_component.interaction_type == interaction_component.InteractionType.DOOR:
						interaction_component.set_dir(current_obj.to_local(interact_cast.get_collision_point()))

func is_cam_locked()->bool:
	if interaction_component:
		if interaction_component.lock_cam and interaction_component.is_interacting:
			return true
	return false
