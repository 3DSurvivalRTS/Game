extends Spatial

class_name FSM

export (Array, Resource) var states: Array
export (Array, Resource) var transitions: Array
export var defaultStateId: int

var defaultState
var currentState
var previousState

var transitionsDic = {}
var stateDic = {}

func _ready():
	for s in states:
		s.initialize(get_parent(), self)
		stateDic[s.id()] = s
	
	defaultState = stateDic[defaultStateId]
	if defaultState:
		set_state(defaultState)
	else:
		push_warning("No default state")
	
	for t in transitions:
		var current = transitionsDic[Vector2(t.fromId(), t.toId())]
		if !current:
			current = []
		transitionsDic[Vector2(t.fromId(), t.toId())] = current.append(t)

func to_previous_or_def():
	if previousState:
		return set_state(previousState)
	else:
		return set_state(defaultState)
		
func to_state(stateId: int):
	var newState = stateDic[stateId]
	if !newState:
		return null
		
	return set_state(newState)

func set_state(newState):
		
	if currentState:
		currentState.exit_state()
		if currentState.save_as_previous():
			previousState = currentState
		
	newState.enter_state()
	currentState = newState
	return currentState
