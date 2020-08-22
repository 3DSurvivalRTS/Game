extends Resource

class_name AgentParamsResource

export(Vector3) var position: Vector3
export(float, 0.1, 20.0) var radius: float = 0.3
export(float, 0.1, 20.0) var height: float = 1.6
export(float, 0.1, 20.0) var maxAcceleration: float = 20.0
export(float, 0.1, 200.0) var maxSpeed: float = 10.0
export(String) var filterName: String = "default"
export(bool) var anticipateTurns: bool = true
export(bool) var optimizeVisibility: bool = true
export(bool) var optimizeTopology: bool = true
export(bool) var avoidObstacles: bool = true
export(bool) var avoidOtherAgents: bool = true
export(int,0,3) var obstacleAvoidance: int = 1
export(float, 0.1, 200.0) var separationWeight: float = 1.0
