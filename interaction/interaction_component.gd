extends Node
class_name InteractionComponent

enum InteractionType{
	DEFAULT,
	DOOR,
	LEVER,
	WHEEL
}

@export var obj_ref:Node3D
@export var interaction_type:InteractionType = InteractionType.DEFAULT
@export var max_rot:float=90
@export var nodes_to_notify:Array[Node]

var can_interact:bool = true
var is_front:bool = false
var is_interacting:bool = false
var lock_cam:bool = false
var start_rot:float
var wheel_rot:float = 0

var cam:Camera3D
var plr_hand:Marker3D
var pivot:Node3D
var prev_mouse_pos:Vector2

func _ready()->void:
	match interaction_type:
		InteractionType.DOOR:
			pivot = get_parent().get_parent().get_parent().find_child("Pivot", true, false)
			start_rot = pivot.rotation.x
			max_rot = deg_to_rad(rad_to_deg(start_rot)+max_rot)
		InteractionType.LEVER:
			start_rot = obj_ref.rotation.z
			max_rot = deg_to_rad(rad_to_deg(start_rot)+max_rot)
		InteractionType.WHEEL:
			start_rot = obj_ref.rotation.z
			max_rot = deg_to_rad(rad_to_deg(start_rot)+max_rot)
			cam = get_tree().get_current_scene().find_child("Camera3D", true, false)
			
func pre_interact(hand:Marker3D)->void:
	is_interacting = true
	match interaction_type:
		InteractionType.DEFAULT:
			plr_hand = hand
		InteractionType.DOOR:
			lock_cam = true
		InteractionType.LEVER:
			lock_cam = true
		InteractionType.WHEEL:
			lock_cam = true
			prev_mouse_pos = get_viewport().get_mouse_position()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

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
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(e: InputEvent) -> void:
	if is_interacting:
		match interaction_type:
			InteractionType.DOOR:
				if e is InputEventMouseMotion:
					pivot.rotate_y(e.relative.y*.001*(-1 if is_front else 1))
					pivot.rotation.y = clamp(pivot.rotation.y, start_rot, max_rot)
			InteractionType.LEVER:
				if e is InputEventMouseMotion:
					obj_ref.rotate_z(e.relative.y*.001)
					obj_ref.rotation.z = clamp(obj_ref.rotation.z, start_rot, max_rot)
					notify((obj_ref.rotation.z - start_rot)/(max_rot-start_rot))
			InteractionType.WHEEL:
				if e is InputEventMouseMotion:
					var mouse_pos = e.position
					wheel_rot += 0.2 * (1.0 if get_cross_product(mouse_pos) > 0 else -1.0)
					obj_ref.rotation.z = wheel_rot*.1
					obj_ref.rotation.z = clamp(obj_ref.rotation.z, start_rot, max_rot)
					prev_mouse_pos = mouse_pos
					notify((obj_ref.rotation.z - start_rot)/(max_rot-start_rot))
					
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

func notify(percent:float)->void:
	for node in nodes_to_notify:
		if node.has_method("interact_notification"):
			node.call("interact_notification", percent)

func get_cross_product(mouse_pos:Vector2)->float:
	var center_pos = cam.unproject_position(obj_ref.global_transform.origin)
	var vec_to_prev = prev_mouse_pos - center_pos
	var vec_to_cur = mouse_pos - center_pos
	return vec_to_cur.x * vec_to_prev.y - vec_to_prev.y * vec_to_prev.x
