extends Node
class_name InteractionComponent

enum InteractionType{
	DEFAULT
}

@export var obj_ref:Node3D
@export var interaction_type:InteractionType = InteractionType.DEFAULT

var can_interact:bool = true
var is_interacting:bool = false
var plr_hand:Marker3D

func _ready()->void:
	pass

func pre_interact(hand:Marker3D)->void:
	is_interacting = true
	match interaction_type:
		InteractionType.DEFAULT:
			plr_hand = hand

func interact()->void:
	if not can_interact:
		return
		
	match interaction_type:
		InteractionType.DEFAULT:
			interact_default()

func aux_interact()->void:
	if not can_interact:
		return
		
	match interaction_type:
		InteractionType.DEFAULT:
			secondary_default()
	
func post_interact()->void:
	is_interacting = false

func _input(e: InputEvent) -> void:
	pass

func interact_default()->void:
	var obj_pos:Vector3 = obj_ref.global_transform.origin
	var plr_hand_pos:Vector3 = plr_hand.global_transform.origin
	var dist:Vector3 = plr_hand_pos-obj_pos
	
	var rigid_body:RigidBody3D = obj_ref as RigidBody3D
	if rigid_body:
		rigid_body.linear_velocity = dist*5/rigid_body.mass
		
func secondary_default()->void:
	var rigid_body:RigidBody3D = obj_ref as RigidBody3D
	if rigid_body:
		var dir:Vector3 = -plr_hand.global_transform.basis.z.normalized()
		var strength:float = (30.0/rigid_body.mass)
		rigid_body.linear_velocity = dir*strength
		can_interact = false
		await get_tree().create_timer(2.0).timeout
		can_interact = true
