extends Spatial

export var is_first_person: bool = false # To be discussed
export var is_current_camera: bool = true
export var mouse_rotation_speed = 0.003
export var controller_rotation_speed = 3.0
export var x_rotation_min = -40
export var x_rotation_max = 60

var camera_x_rot = 0.0


onready var camera_rot = $CameraRotation
onready var camera_spring_arm = $CameraRotation/SpringArm
onready var camera_camera = $CameraRotation/SpringArm/Camera

func _ready():
	camera_camera.current = is_current_camera

func _process(delta):
	if is_first_person:
		camera_spring_arm.spring_length = 0
		x_rotation_min = -60
	else:
		camera_spring_arm.spring_length = 5
		x_rotation_min = -40
	
	if camera_camera.current != is_current_camera:
		camera_camera.current = is_current_camera

func _input(event):
	if event is InputEventMouseMotion:
		var camera_speed_this_frame = mouse_rotation_speed
		rotate_camera(event.relative * camera_speed_this_frame)
	

func rotate_camera(move):
	self.rotate_y(-move.x)
	self.orthonormalize()
	camera_x_rot -= move.y
	camera_x_rot = clamp(camera_x_rot, deg2rad(x_rotation_min), deg2rad(x_rotation_max))
	camera_rot.rotation.x = camera_x_rot
