tool
extends Node2D

export var persents: Vector2 = Vector2(0.5, 0.5)
export var positionOffset: Vector2 = Vector2(0.0, 0.0)

func _ready():
	move()
	get_tree().get_root().connect("size_changed", self, "move")
	
func move():
	var vSize := get_viewport_rect().size
	self.position = (persents * vSize) + positionOffset
	
