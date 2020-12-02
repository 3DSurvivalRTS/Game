extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	pass

func _input(event):
	if event is InputEventKey && event.is_pressed():
		var id = randi()
		var task = BackgroundTask.new()
		task.funcRef = funcref(self, "print_message")
		task.params = event.as_text() + " [id: " + str(id) + "]"
		print("Pressrd: " + event.as_text() + " [id: " + str(id) + "]")
		$BackgroundTasks._add_task(task)

func print_message(message):
	yield(get_tree().create_timer(10.0), "timeout")
	print("Message: " + message)
