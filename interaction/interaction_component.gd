extends Node
class_name InteractionComponent

enum InteractionType{
	DEFAULT,
	DOOR
}

@export var obj_ref:Node3D
@export var interaction_type:InteractionType = InteractionType.DEFAULT
@export var max_rot:float=90

var can_interact:bool = true
var is_front:bool = false
var is_interacting:bool = false
var lock_cam:bool = false
var start_rot:float

var plr_hand:Marker3D
var pivot:Node3D

func _ready()->void:
	match interaction_type:
		InteractionType.DOOR:
			pivot = get_parent().get_parent().get_parent().find_child("Pivot", true, false)
			start_rot = pivot.rotation.x
			max_rot = deg_to_rad(rad_to_deg(start_rot)+max_rot)
			
func pre_interact(hand:Marker3D)->void:
	is_interacting = true
	match interaction_type:
		InteractionType.DEFAULT:
			plr_hand = hand
		InteractionType.DOOR:
			lock_cam = true

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
	lock_cam = false

func _input(e: InputEvent) -> void:
	if is_interacting:
		match interaction_type:
			InteractionType.DOOR:
				if e is InputEventMouseMotion:
					pivot.rotate_y(e.relative.y*.001*(-1 if is_front else 1))
					pivot.rotation.y = clamp(pivot.rotation.y, start_rot, max_rot)

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

func set_dir(normal:Vector3)->void:
	is_front = normal.z > 0
