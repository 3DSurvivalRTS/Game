extends Node

class_name FSM

var state: BaseState = null
var previous_state: BaseState = null
export (Array, Resource) var states
export (Array, Resource) var transitions

onready var parent = get_parent()

func initialize(animation_player: AnimationPlayer):
	for state in states:
		state.initialize(animation_player)
	if len(states) != 0:
		_initialize_state(states[0].id())

func _physics_process(delta):
	if state != null:
		state.state_logic(delta)
#		var transition = _get_transition(delta)
#		if transition != null:
#			_set_state(transition)

func _enter_state(new_state, old_state):
	pass	
	
func _exit_state(old_state, new_state):
	old_state.exit()
	
func _get_transition(root_state_id):
	for transition in transitions:
		if transition.root_state_id() == root_state_id:
			return transition 
	return null
	
func _initialize_state(new_state_id):
	var pending_state = _verify_state(new_state_id)
	if pending_state == null:
		return 
	state = pending_state	
	
func set_state(new_state_id):
	var pending_state = _verify_state(new_state_id)
	if pending_state == null:
		return 
	
	var transition = _get_transition(state.id())
	if !transition:
		return
	if !transition.verify_transition(new_state_id):
		return
		
	previous_state = state
	state = pending_state
	
	if previous_state != null:
		_exit_state(previous_state, pending_state)
	if pending_state != null:
		_enter_state(pending_state, previous_state)	
	return state.id()
	
	
func _verify_state(state_id: int):
	for _state in states:
		if _state.id() == state_id:
			return _state
	return null
	
func get_state() -> BaseState:
	if state != null:
		return state
	return BaseState.new()
