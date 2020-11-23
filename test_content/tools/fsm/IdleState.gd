extends BaseState

class_name IdleState

static func id() -> int:
	return 1

func get_name():
	return "Idle"

func state_logic(delta):
	_animation_player.play("idle")

func exit():
	_animation_player.stop()

	
