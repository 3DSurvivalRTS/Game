extends Node

enum DROP {
	DROP_NEW,
	DROP_OLD
}

export var thread_count := 3
export var task_buffer_size := 100
export(DROP) var on_full_drop := DROP.DROP_NEW

var threads = []
var task_mutex: Mutex
var semaphore: Semaphore

var tasks_to_do = []
var tasks_counter := 0

var terminated = false

func _ready():
	task_mutex = Mutex.new()
	for i in range(thread_count):
		var thread = Thread.new()
		thread.start(self, 'process_tasks')
		threads.push_back(thread)
	semaphore = Semaphore.new()
	
func _add_task(task: BackgroundTask) -> int:
	task_mutex.lock()
	
	if !check_task_count():
		return 0
	
	tasks_counter += 1
	task.id = tasks_counter
	tasks_to_do.push_back(task)
	
	semaphore.post()
	task_mutex.unlock()
	
	return tasks_counter

func process_tasks(data):
	while(!terminated):
		task_mutex.lock()
		var task = tasks_to_do.pop_front()
		if task:
			task_mutex.unlock()
			execute_task(task)
			continue
		else:
			task_mutex.unlock()
			semaphore.wait()
			
func execute_task(task: BackgroundTask):
	var res = task.func_ref.call_funcv(task.params)
	print(str(res))
	if task.call_back:
		task.call_back.call_func(res)
	
func check_task_count() -> bool :
	if tasks_to_do.size() < task_buffer_size:
		return true
		
	if on_full_drop == DROP.DROP_NEW:
		return false
		
	tasks_to_do.pop_front()
	return true
			
func _exit_tree():
	terminated = true
