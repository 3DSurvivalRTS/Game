extends Spatial


func _input(event):
	if event is InputEventKey && event.is_pressed():
		var id = randi()
		var task = BackgroundTask.new()
		task.func_ref = funcref(self, "print_message")
		task.params = [event.as_text(), " [id: " + str(id) + "]"]
		task.call_back = funcref(self, "success_message")
		print("Pressrd: " + event.as_text() + " [id: " + str(id) + "]")
		$BackgroundTasks._add_task(task)

func print_message(message, description):
	yield(get_tree().create_timer(1.0), "timeout")
	print("Message: " + str(message) + str(description))
	return ("Complited: " + str(message) + str(description))

func success_message(result):
	print("Result: " + str(result))
