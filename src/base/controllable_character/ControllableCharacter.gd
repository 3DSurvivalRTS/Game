tool
extends Entity


class_name ControllableCharacter

export var is_active: bool = false setget set_character_state
export var controller_path: NodePath
export var camera_path: NodePath

var controller: ControllerComponent
var camera: CameraComponent
# Called when the node enters the scene tree for the first time.
func _ready():
	assert(controller_path != NodePath(), "ERROR: Missiing controller in ControllableCharacter")
	assert(camera_path != NodePath(), "ERROR: Missiing controller in ControllableCharacter")
	controller = get_node(controller_path)
	camera = get_node(camera_path)

func set_character_state(state: bool):
	is_active = state
	if is_active:
		controller.enable()
		camera.enable()
	else:
		controller.disable()
		camera.disable()
		
