tool
extends Node

class_name Navi

const DetourNavigation :NativeScript = preload("res://addons/godotdetour/detournavigation.gdns")
const DetourNavigationParameters :NativeScript = preload("res://addons/godotdetour/detournavigationparameters.gdns")
const DetourNavigationMeshParameters :NativeScript = preload("res://addons/godotdetour/detournavigationmeshparameters.gdns")
const DetourCrowdAgent :NativeScript = preload("res://addons/godotdetour/detourcrowdagent.gdns")
const DetourCrowdAgentParameters :NativeScript = preload("res://addons/godotdetour/detourcrowdagentparameters.gdns")
const DetourObstacle :NativeScript = preload("res://addons/godotdetour/detourobstacle.gdns")

var navigation = null
var debugMeshInstance :MeshInstance = null
var navMeshToDisplay :int = 0
var _meshInstance : MeshInstance = null

# Приходится экспортировать как Resurce и выбирать нужный тип,
# т.к сейчас gd ломается при указании кастомного типа  
# Должно пофикситься с задачей: https://github.com/godotengine/godot-proposals/issues/18
export(Resource) var navParams
export(Array, Resource) var navMeshsConfigs
export(NodePath) var meshInstance setget setMeshInstance
export(Array, Resource) var fewQueryFilters
export(bool) var drawDebug:=false

signal navigation_tick

func _ready():
	initializeNavigation()

func initializeNavigation():
	# Create the navigation parameters
	var navP = DetourNavigationParameters.new()
	navP.ticksPerSecond = navParams.ticksPerSecond
	navP.maxObstacles = navParams.maxObstacles

	for m in navMeshsConfigs:
		var navMeshParams = DetourNavigationMeshParameters.new()
		navMeshParams.cellSize = m.cellSize
		navMeshParams.maxNumAgents = m.maxNumAgents
		navMeshParams.maxAgentSlope = m.maxAgentSlope
		navMeshParams.maxAgentHeight = m.maxAgentHeight
		navMeshParams.maxAgentClimb = m.maxAgentClimb
		navMeshParams.maxAgentRadius = m.maxAgentRadius
		navMeshParams.maxEdgeLength = m.maxEdgeLength
		navMeshParams.maxSimplificationError = m.maxSimplificationError
		navMeshParams.minNumCellsPerIsland = m.minNumCellsPerIsland
		navMeshParams.minCellSpanCount = m.minCellSpanCount
		navMeshParams.maxVertsPerPoly = m.maxVertsPerPoly
		navMeshParams.tileSize = m.tileSize
		navMeshParams.layersPerTile = m.layersPerTile
		navMeshParams.detailSampleDistance = m.detailSampleDistance
		navMeshParams.detailSampleMaxError = m.detailSampleMaxError
		navP.navMeshParameters.append(navMeshParams)
	
	navigation = DetourNavigation.new()
	initNavigation(navigation, navP)

	for f in fewQueryFilters:
		var weights :Dictionary = {}
		weights[0] = f.ground
		weights[1] = f.road
		weights[2] = f.water
		weights[3] = f.door
		weights[4] = f.grass
		weights[5] = f.jump
		navigation.setQueryFilter(0, f.filterName, weights)
	
	navigation.connect("navigation_tick_done", self, "navigationTickDone")
	#yield(navigation, "navigation_tick_done")
	if Engine.editor_hint && drawDebug:
		yield(get_tree(), "idle_frame")
		drawDebugMesh()
	
func navigationTickDone(tickTime):
	emit_signal('navigation_tick', navigation, tickTime)

func initNavigation(nav: DetourNavigation, navP: DetourNavigationParameters):
	if _meshInstance:
		navigation.initialize(_meshInstance, navP)
	elif Engine.editor_hint:
		printerr("No mesh instance")

# Защита на всякий случай, т.к. нет возможности явно указать тип при экспорте 
# NodePath
# Есть issue: https://github.com/godotengine/godot-proposals/issues/1048
func setMeshInstance(path):
	meshInstance = path
	var node = get_node(path)
	if node && node is MeshInstance:
		self._meshInstance = node
	elif Engine.editor_hint:
		printerr("Property meshInstance must be a MeshInstance")
	else: 
		meshInstance = null
		self._meshInstance = null

func drawDebugMesh() -> void:
	# Don't do anything if navigation is not initialized
	if not navigation.isInitialized():
		return
	
	# Free the old instance
	if debugMeshInstance != null:
		remove_child(debugMeshInstance)
		debugMeshInstance.queue_free()
		debugMeshInstance = null

	# Create the debug mesh
	debugMeshInstance = navigation.createDebugMesh(navMeshToDisplay, false)
	if !debugMeshInstance:
		printerr("Debug meshInst invalid!")
		return

	# Add the debug mesh instance a little elevated to avoid flickering
	debugMeshInstance.translation = _meshInstance.translation + Vector3(0.0, 0.05, 0.0)
	if _meshInstance:
		debugMeshInstance.rotation = _meshInstance.rotation
	_meshInstance.add_child(debugMeshInstance)
	print(debugMeshInstance.scale)
