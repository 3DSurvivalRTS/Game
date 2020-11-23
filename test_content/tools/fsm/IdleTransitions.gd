extends BaseTransitions


class_name IdleTransitions


func root_state_id() -> int:
	return IdleState.id()

func possible_transition_ids() -> Array:
	return [WalkingState.id()]
