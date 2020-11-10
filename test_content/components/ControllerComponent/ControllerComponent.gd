extends Spatial

onready var parent: KinematicBody = get_parent()

export var rotatable_model_path: NodePath
export var direction_interpolate_speed = 1
export var motion_interpolate_speed = 10
export var rotation_interpolate_speed = 10
export (int, 0, 200) var push = 100

export var speed: int = 10
export var acceleration: int = 5

var orientation = Transform()
var root_motion = Transform()
var motion = Vector2()
var velocity = Vector3()
var camera
var model


var is_controllable = false
var is_mouse_captured = true

func _ready():
	camera = parent.get_node("CameraComponent")
	if camera != null:
		is_controllable = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	
	model = get_node(rotatable_model_path)

func _physics_process(delta):
	if not is_controllable:
		return
	var motion_target = Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
			)
	motion = motion.linear_interpolate(motion_target, motion_interpolate_speed * delta)
	
	var camera_basis = camera.global_transform.basis
	var camera_z = camera_basis.z
	var camera_x = camera_basis.x
	
	camera_z.y = 0
	camera_z = camera_z.normalized()
	camera_x.y = 0
	camera_x = camera_x.normalized()
	
	var target = camera_x * motion.x + camera_z * motion.y
	if target.length() > 0.001:
		var q_from = orientation.basis.get_rotation_quat()
		var q_to = Transform().looking_at(target, Vector3.UP).basis.get_rotation_quat()
		orientation.basis = Basis(q_from.slerp(q_to, delta * rotation_interpolate_speed))
	
	
	var motion_abs = motion.abs()
	var root_motion_c = (motion_abs.x + motion_abs.y)
	if root_motion_c > 1:
		root_motion_c = 1
	root_motion = Transform(
		Vector3(1, 0, 0),
		Vector3(0, 1, 0),
		Vector3(0, 0, 1),
		Vector3(0, 0, (root_motion_c/100.0*speed))
		)
	orientation *= root_motion
	
	var h_velocity = -orientation.origin / delta
	velocity.x = h_velocity.x
	velocity.z = h_velocity.z
	velocity.y += -9.8 * delta
	velocity = parent.move_and_slide(velocity, Vector3(0, 1, 0), false, 4, 0.785398, false)
	
	orientation.origin = Vector3() 
	orientation = orientation.orthonormalized() 
	
	if model != null:
		model.global_transform.basis = orientation.basis
		
	for index in parent.get_slide_count():
		var collision = parent.get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
			collision.collider.apply_central_impulse(-collision.normal * push)

func _input(event):
	if event.is_action_pressed("action_jump"):
		velocity.y += 6
	if event.is_action_pressed("ui_cancel"):
		if is_mouse_captured:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			is_mouse_captured = false
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			is_mouse_captured = true
	
