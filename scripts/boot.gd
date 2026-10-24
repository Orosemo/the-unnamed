extends Node

# everything that has to happen before the game starts 

signal boot_complete

func _ready() -> void:
	load_keybinds()

func load_keybinds():
	print("loadkeybinds...")
	var keybinds = SaveManager.load_config("keybinds", "settings")

	if keybinds == null:
		print("no keybinds :(")
		return
	
	for bind in keybinds:
		InputMap.action_erase_events(bind)
		for action in keybinds[bind]:
			InputMap.action_add_event(bind, action)
			print( str(bind) + str(action))

	boot_complete.emit()

	print("keybinds loaded :)")
