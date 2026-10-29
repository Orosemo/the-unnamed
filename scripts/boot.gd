extends Node

# everything that has to happen before the game starts 

signal boot_complete

func _ready() -> void:
	load_keybinds()
	_load_sound()

func load_keybinds():
	var keybinds = SaveManager.load_config("keybinds", "settings")

	if keybinds == null:
		return
	
	for bind in keybinds:
		InputMap.action_erase_events(bind)
		print(bind)
		print(keybinds[bind])
		for action in keybinds[bind]:
			InputMap.action_add_event(bind, action)

	boot_complete.emit()

func _load_sound():
	if (
		SaveManager.load_config("music_mute", "settings") != null
		and SaveManager.load_config("sfx_mute", "settings") != null
		and SaveManager.load_config("music_volume", "settings") != null
		and SaveManager.load_config("sfx_volume", "settings") != null
		):

		AudioServer.set_bus_mute(1, SaveManager.load_config("music_mute", "settings"))
		AudioServer.set_bus_mute(2, SaveManager.load_config("sfx_mute", "settings"))

		AudioServer.set_bus_volume_db(1, SaveManager.load_config("music_volume", "settings"))
		AudioServer.set_bus_volume_db(2, SaveManager.load_config("sfx_volume", "settings"))
	else:
		SaveManager.save_config(false, "music_mute", "settings")
		SaveManager.save_config(false, "sfx_mute", "settings")
		SaveManager.save_config(100 ,"music_volume", "settings")
		SaveManager.save_config(100, "sfx_volume", "settings")