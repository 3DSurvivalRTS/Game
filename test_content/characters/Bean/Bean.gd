extends KinematicBody


onready var animation_player = $AnimationPlayer
onready var fsm = $FSM
onready var debug_label = $DebugLabel3D

func _ready():
	fsm.initialize(animation_player)

func _process(delta):
	debug_label.text = fsm.get_state().get_name()
