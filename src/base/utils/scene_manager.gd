extends Node

var loading = preload("res://src/ui/loading/Loading.tscn").instance()
var _resorceQueue: ResourceQueue = ResourceQueue.new()
var isLoading:= false
var goto:String

func _ready():
	_resorceQueue.start()
	
func go_to_scene_with_loading(path: String):
	if isLoading:
		return false
	isLoading = true
	goto = path
	_resorceQueue.queue_resource(goto)
	var root = get_tree().get_root()
	var current_scene = root.get_child(root.get_child_count() -1)
	current_scene.queue_free()
	root.call_deferred("add_child", loading)

func _process(delta):
	if isLoading && goto && _resorceQueue.is_ready(goto):
		var newScene = _resorceQueue.get_resource(goto).instance()
		var root = get_tree().get_root()
		var current_scene = root.get_child(root.get_child_count() -1)
		current_scene.queue_free()
		root.add_child(newScene)
		isLoading = false
		goto = ""
	if isLoading && !goto:
		isLoading = false
