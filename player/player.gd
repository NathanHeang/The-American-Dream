extends CharacterBody3D

@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5
@export_range(0.0, 1.0) var mouse_sensitivity = 0.01
@export var tilt_limit = deg_to_rad(75)

@onready var cam_pivot: Node3D = $CameraPivot
@onready var camera_3d: Camera3D = $CameraPivot/Camera3D

@onready var look: RayCast3D = $RayCast3D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_dir := Input.get_vector("l", "r", "fw", "bw")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
	
	if look.is_colliding():
		var hit = look.get_collider()
		if hit.has_method("looked_at"):
			hit.call("looked_at")
		if hit.has_method("interact") or hit.has_method("interact_alt"):
			pass
		if Input.is_action_just_pressed("interact") and hit.has_method("interact"):
			hit.call("interact")
		if Input.is_action_just_pressed("interact_alt") and hit.has_method("interact_alt"):
			hit.call("interact_alt")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		cam_pivot.rotation.x -= event.screen_relative.y * mouse_sensitivity
		cam_pivot.rotation.x = clampf(cam_pivot.rotation.x, -tilt_limit, tilt_limit)
		rotation.y += -event.screen_relative.x * mouse_sensitivity
