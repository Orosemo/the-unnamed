extends VBoxContainer
class_name StatusMessageBox

@export var label: String
@export var duration: float

var labels := []

func add_message(message: String):
	var new_label = load(label).instantiate()
	new_label.text = message
	self.add_child(new_label)
	labels.append(new_label)
	var timer = get_tree().create_timer(duration)
	timer.timeout.connect(new_label.kill)
