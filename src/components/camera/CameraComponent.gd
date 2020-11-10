extends Spatial

class_name CameraComponent

export var is_first_person: bool = false # To be discussed
export var is_current_camera: bool = true
export var mouse_rotation_speed = 0.003
export var controller_rotation_speed = 3.0
export var x_rotation_min = -40
export var x_rotation_max = 60
export var spring_arm_length = 5
var camera_x_rot = 0.0


onready var camera_rot = $CameraRotation
onready var camera_spring_arm = $CameraRotation/SpringArm
onready var camera_camera = $CameraRotation/SpringArm/Camera

func _ready():
	camera_camera.current = is_current_camera
	camera_spring_arm.spring_length = spring_arm_length
func _process(delta):
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

func disable():
	camera_camera.clear_current()
func enable():
	camera_camera.make_current()
	
