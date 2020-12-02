extends Resource

class_name BaseState

signal finish

func id() -> int:
	return 0

func enter_state():
	pass
	
func exit_state():
	pass

func initialize(root: Spatial, fsm):
	pass

func save_as_previous() -> bool:
	return true
