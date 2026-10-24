extends Control

const INPUT_BUTTON = preload("uid://u5fue0ggdtcr")
@onready var buttons: VBoxContainer = $Panel/MarginContainer/VBoxContainer/ScrollContainer/buttons

var is_remapping = false
var action_to_remap = null
var remapping_button = null

var input_actions = {
	"left": "Move left",
	"right": "Move right",
	"jump": "Jump",
	"duck": "Duck",
	"escape": "escape / Pause",
	"run": "Run",
	"inventory": "Open inventory",
	"back": "go back (controler only)",
	"fastquit": "instant quit",
	"interact": "Interact"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Boot.boot_complete.connect(_create_action_list)
	_create_action_list()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _create_action_list():
	InputMap.load_from_project_settings()

	for child in buttons.get_children():
		child.queue_free

	for action in input_actions:
		var button = INPUT_BUTTON.instantiate()
		var name_label : Label = button.find_child("name")
		var action_label : Label = button.find_child("action")

		name_label.text = input_actions[action]

		var events = InputMap.action_get_events(action)

		if events.size() > 0:
			action_label.text = events[0].as_text().trim_suffix(" - Physical")
		else:
			action_label.text = "Not bound"
		
		buttons.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))


func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("action").text = "Press key to bind..."


func _input(event: InputEvent) -> void:
	if is_remapping:
		if (
			event is InputEventKey or 
			(event is InputEventMouseButton) or 
			(event is InputEventJoypadButton) or 
			(event is InputEventJoypadMotion)
		):
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(StringName(action_to_remap), event)
			_update_action_list(remapping_button, event)

			save_keybinds()

			is_remapping = false
			action_to_remap = null
			remapping_button = null

func _update_action_list(button, event):
	button.find_child("action").text = event.as_text().trim_suffix(" - Physical")

func save_keybinds():
	var actions = InputMap.get_actions()

	var save_actions = {}

	for action in input_actions:
		save_actions[action] = InputMap.action_get_events(action)

		SaveManager.save_config(save_actions, "keybinds", "settings")
		print("keybinds saved :) = " + String(action))
		print(InputMap.action_get_events(action))
