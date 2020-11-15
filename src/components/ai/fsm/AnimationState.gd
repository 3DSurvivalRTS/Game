extends "res://src/components/ai/fsm/BaseState.gd"

class_name AnimationState

export var id: int
export var canBack: bool
export var animation: String
export (NodePath) var animator: NodePath

var animatorNode: AnimationPlayer
var fsm

func id():
	return id

func initialize(root: Spatial, fsm):
	self.fsm = fsm
	self.animatorNode = fsm.get_node(animator)
	if !animatorNode:
		push_warning("No animatorNode")

func enter_state():
	if animatorNode:
		self.animatorNode.play(animation)
		self.animatorNode.connect("animation_finished", self, "animationFinished")
	
func exit_state():
	if animatorNode:
		self.animatorNode.stop()
		self.animatorNode.disconnect("animation_finished", self, "animationFinished")

func animationFinished(animName: String):
	if animName==animation:
		fsm.to_previous_or_def()

func save_as_previous():
	return canBack
