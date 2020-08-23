extends KinematicBody

export var target_path:NodePath

var target:Spatial

var velocity = Vector3()
var speed = 10
var acceleration = 5 
var deacceleration = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_node(target_path)


func _physics_process(delta):
	follow(target, delta)
	velocity.y -= 9.8 * delta
	move_and_slide(velocity, Vector3(0, 1, 0))

func follow(target: Spatial, delta):
	var direction = Vector3()
	var target_pos = target.transform.origin
	var distance_to_target = target_pos.distance_to(transform.origin)
	if distance_to_target > 5:
		var dir_target = target_pos.direction_to(transform.origin).normalized()
		direction += dir_target * speed
		direction.y = 0	
		velocity = velocity.linear_interpolate(-direction, acceleration * delta)
	else:
		velocity = velocity.linear_interpolate(Vector3(), deacceleration * delta)
