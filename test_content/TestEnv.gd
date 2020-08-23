extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	for child in get_children():
		if child.transform.origin.y < -5:
			child.transform.origin = Vector3 (0, 110, 0)
			child.rotation = Vector3(0, 0, 0)
#			child.linear_velocity = Vector3(0, 0, 0)
