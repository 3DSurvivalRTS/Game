extends Object

const DetourNavigation :NativeScript = preload("res://addons/godotdetour/detournavigation.gdns")
const DetourCrowdAgent :NativeScript = preload("res://addons/godotdetour/detourcrowdagent.gdns")
const DetourCrowdAgentParameters :NativeScript = preload("res://addons/godotdetour/detourcrowdagentparameters.gdns")

class_name AgentManager

var nav: DetourNavigation = null

func _init(navigation: DetourNavigation):
	self.nav = navigation

func createAgent(params: AgentParamsResource) -> MovableAgent:
	var agentParams := convertToDetourParams(params)
	var detourCrowdAgent = nav.addAgent(agentParams)
	if detourCrowdAgent == null:
		return null
	else:
		return MovableAgent.new(detourCrowdAgent)
		
func removeAgent(agentToRemove: MovableAgent):
	nav.removeAgent(agentToRemove.agent)

func convertToDetourParams(p: AgentParamsResource) -> DetourCrowdAgentParameters:
	var agentParams = DetourCrowdAgentParameters.new()
	agentParams.position = p.position
	agentParams.radius = p.radius
	agentParams.height = p.height
	agentParams.maxAcceleration = p.maxAcceleration
	agentParams.maxSpeed = p.maxSpeed
	agentParams.filterName = p.filterName
	agentParams.anticipateTurns = p.anticipateTurns
	agentParams.optimizeVisibility = p.optimizeVisibility
	agentParams.optimizeTopology = p.optimizeTopology
	agentParams.avoidObstacles = p.avoidObstacles
	agentParams.avoidOtherAgents = p.avoidOtherAgents
	agentParams.obstacleAvoidance = p.obstacleAvoidance
	agentParams.separationWeight = p.separationWeight
	return agentParams
