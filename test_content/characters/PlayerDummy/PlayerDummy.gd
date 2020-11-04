extends KinematicBody


onready var camera = $CameraComponent

const DIRECTION_INTERPOLATE_SPEED = 1
const MOTION_INTERPOLATE_SPEED = 10
const ROTATION_INTERPOLATE_SPEED = 10

var orientation = Transform()
var root_motion = Transform()
var motion = Vector2()
var velocity = Vector3()

var speed = 10
var acceleration = 5


func _process(delta):
	pass
	
func _physics_process(delta):
	
	var motion_target = Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
			)
	motion = motion.linear_interpolate(motion_target, MOTION_INTERPOLATE_SPEED * delta)
	
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
		orientation.basis = Basis(q_from.slerp(q_to, delta * ROTATION_INTERPOLATE_SPEED))
	
	
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
	velocity = move_and_slide(velocity, Vector3(0, 1, 0))
	
	orientation.origin = Vector3() 
	orientation = orientation.orthonormalized() 
	
	$Model.global_transform.basis = orientation.basis

func _input(event):
	if event.is_action_pressed("action_jump"):
		velocity.y += 6
	
	
