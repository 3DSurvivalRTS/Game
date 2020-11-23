extends Resource


class_name BaseTransitions


func root_state_id() -> int:
	return 0

func possible_transition_ids() -> Array:
	return []

func verify_transition(state_id: int):
	if state_id in possible_transition_ids():
		return true
	return false



