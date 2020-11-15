extends "res://src/components/ai/fsm/BaseState.gd"

class_name TimerState

export var id: int
export var time: float
export (Resource) var delegate: Resource

var fms
var root
var timer: SceneTreeTimer

func id():
	return delegate.id() if !id  else id

func initialize(root: Spatial, fsm):
	self.fms = fms
	self.root = root
	delegate.initialize(root, fsm)

func enter_state():
	delegate.enter_state()
	timer = root.get_tree().create_timer(time, false)
	timer.connect("timeout", self, "timeout")
	
func exit_state():
	if timer:
		timer.disconnect("timeout", self, "timeout")
	delegate.exit_state()

func timeout():
	fms.to_previous_or_def()
