extends BaseTransitions

class_name WalkingTransitions

func root_state_id() -> int:
	return WalkingState.id()

func possible_transition_ids() -> Array:
	return [IdleState.id()]
