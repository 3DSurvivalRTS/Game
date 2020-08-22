extends Node
const DetourCrowdAgent :NativeScript = preload("res://addons/godotdetour/detourcrowdagent.gdns")
class_name MovableAgent

# Тип: DetourCrowdAgent, если указывать его явно, godot ломается при попытке привести
var agent = null
var parent: Node = null
var currentTarget: Vector3 = Vector3.ZERO
var lastUpdateTimestamp: int = OS.get_ticks_msec()

export var usePrediction := true

signal on_stop(agent)
signal on_new_target(agent)
signal on_arrived(agent)
signal on_no_progress(agent, distanceLeft)
signal on_no_movement(agent, distanceLeft)
signal on_start_off_mesh_connection(agent, position)
signal on_end_off_mesh_connection(agent, position)

func _init(detourAgent):
	self.agent = detourAgent
	
func _ready():
	if !agent:
		return
	agent.connect("arrived_at_target", self, "onAgentArrived", [], CONNECT_DEFERRED)
	agent.connect("no_progress", self, "onAgentNoProgress", [], CONNECT_DEFERRED)
	agent.connect("no_movement", self, "onAgentNoMovement", [], CONNECT_DEFERRED)
	agent.connect("on_mesh_connection_end", self, "onAnimEnd", [], CONNECT_DEFERRED)
	agent.connect("on_mesh_connection_start", self, "onAnimStart", [], CONNECT_DEFERRED)

func _process(delta):
	if agent.isMoving == true:
		if usePrediction:
			var result :Dictionary = agent.getPredictedMovement(parent.translation, -parent.global_transform.basis.z, lastUpdateTimestamp, deg2rad(2.5))
			parent.translation = result["position"]
			parent.look_at(parent.translation + result["direction"], parent.transform.basis.y)
		else:
			parent.translation = agent.position
			parent.look_at(parent.translation + agent.velocity, parent.transform.basis.y)
	# Remember time of update
	lastUpdateTimestamp = OS.get_ticks_msec()

func setParent(parent: Node):
	self.parent = parent
	
func stop():
	agent.stop()
	self.emit_signal("on_stop", self)

func setTargetPosition(position: Vector3):
	self.currentTarget = position
	agent.moveTowards(position)
	self.emit_signal("on_new_target", self)
	
func onAgentArrived(detourAgent):
	print("Detour agent ", detourAgent, " arrived at ", detourAgent.target)
	self.emit_signal("on_arrived", self)

func onAgentNoProgress(detourAgent, distanceLeft :float):
	if distanceLeft < 1.5 * parent.scale.x:
		stop()
	self.emit_signal("on_no_progress", self, distanceLeft)

func onAgentNoMovement(detourAgent, distanceLeft :float):
	if distanceLeft < 0.75 * parent.scale.x:
		stop()
	self.emit_signal("on_no_movement", self, distanceLeft)
		
func onAnimEnd(detourAgent, position :Vector3):
	print("Detour agent ", detourAgent, " reported onAnimEnd. Position: ", position)
	self.emit_signal("on_start_off_mesh_connection", self, position)
		
func onAnimStart(detourAgent, position :Vector3):
	print("Detour agent ", detourAgent, " reported onAnimStart. Position: ", position)
	self.emit_signal("on_end_off_mesh_connection", self, position)
