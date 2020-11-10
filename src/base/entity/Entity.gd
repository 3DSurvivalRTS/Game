extends Spatial

class_name Entity

export var health: int
export var damage: int
export var movement_speed: int
export var model_path: NodePath
export var hitbox_path: NodePath

var model
var hitbox

func _ready():
	assert(model_path != NodePath(), "ERROR: No Model was assigned to entity")
	assert(hitbox_path != NodePath(), "ERROR: No Hitbox was assigned to entity")
	model = get_node(model_path)
	hitbox = get_node(hitbox_path)
