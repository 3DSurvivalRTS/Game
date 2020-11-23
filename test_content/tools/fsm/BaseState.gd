extends Resource


class_name BaseState
var _animation_player: AnimationPlayer

func initialize(animation_player: AnimationPlayer):
	_animation_player = animation_player

static func id() -> int:
	return 0

func state_logic(delta):
	pass
	
func get_name():
	return "None"
	
func exit():
	pass
