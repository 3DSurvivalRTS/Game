extends BaseState

class_name WalkingState

static func id() -> int:
	return 2

func get_name():
	return "Walking"

func state_logic(delta):
	_animation_player.play("walking")	
	
func exit():
	_animation_player.stop()
