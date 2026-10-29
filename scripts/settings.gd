extends MarginContainer

const INPUT_BUTTON = preload("uid://u5fue0ggdtcr")
@onready var buttons: VBoxContainer = $Keybinds/Panel/MarginContainer/VBoxContainer/ScrollContainer/buttons

@onready var general: Button = $nav/Panel/MarginContainer/VBoxContainer/General
@onready var music_sound: Button = $nav/Panel/MarginContainer/VBoxContainer/Music_Sound
@onready var keybinds: Button = $nav/Panel/MarginContainer/VBoxContainer/Keybinds

@onready var general_container: Control = $General
@onready var music_sound_container: Control = $music_sound
@onready var keybinds_container: Control = $Keybinds

@onready var sfx_display: Label = $music_sound/Panel/MarginContainer/VBoxContainer/sfx/display
@onready var music_display: Label = $music_sound/Panel/MarginContainer/VBoxContainer/music/display

@onready var pages = {
	"general": $General,
	"music": $music_sound,
	"keybinds": $Keybinds
}

@onready var page_buttons = {
	"general": $nav/Panel/MarginContainer/VBoxContainer/General,
	"music": $nav/Panel/MarginContainer/VBoxContainer/Music_Sound,
	"keybinds": $nav/Panel/MarginContainer/VBoxContainer/Keybinds
}

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
	$music_sound/Panel/MarginContainer/VBoxContainer/music/music.value = AudioServer.get_bus_volume_db(1)
	$music_sound/Panel/MarginContainer/VBoxContainer/sfx/sfx.value = AudioServer.get_bus_volume_db(2)
	music_display.text = str($music_sound/Panel/MarginContainer/VBoxContainer/music/music.value)
	sfx_display.text = str($music_sound/Panel/MarginContainer/VBoxContainer/sfx/sfx.value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _create_action_list():
	for child in buttons.get_children():
		child.queue_free()

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
	var save_actions = {}

	for action in input_actions:
		save_actions[action] = InputMap.action_get_events(action)

	SaveManager.save_config(save_actions, "keybinds", "settings")
	print("keybinds saved :)")


func _change_page(to: String):
	for page in pages:
		pages[page].visible = false

	pages[to].visible = true

	for button in page_buttons:
		page_buttons[button].disabled = false

	page_buttons[to].disabled = true

func _on_general_pressed() -> void:
	_change_page("general")


func _on_music_sound_pressed() -> void:
	_change_page("music")


func _on_keybinds_pressed() -> void:
	_change_page("keybinds")


func _on_window_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)


func _on_resolution_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1020, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		2:
			DisplayServer.window_set_size(Vector2i(1280, 720))
		3:
			DisplayServer.window_set_size(Vector2i(3440, 1080))
		4:
			DisplayServer.window_set_size(Vector2i(1152, 648))

func _on_music_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(1, toggled_on)
	SaveManager.save_config(toggled_on, "music_mute", "settings")

func _on_sfx_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(2, toggled_on)
	SaveManager.save_config(toggled_on, "sfx_mute", "settings")


func _on_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_mute(2, false)
	sfx_display.text = str(value)
	AudioServer.set_bus_volume_db(2, value)
	SaveManager.save_config(value, "sfx_volume", "settings")

func _on_music_value_changed(value: float) -> void:
	AudioServer.set_bus_mute(1, false)
	music_display.text = str(value)
	AudioServer.set_bus_volume_db(1, value)
	SaveManager.save_config(value, "music_volume", "settings")
