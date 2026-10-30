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
	var music_bus = AudioServer.get_bus_index(&"music")
	var sfx_bus = AudioServer.get_bus_index(&"sfx")
	if music_bus == -1 or sfx_bus == -1:
		push_error("Audio buses 'music' and 'sfx' must exist in the bus layout")
		return

	var music_mute = SaveManager.load_config("music_mute", "settings")
	var sfx_mute = SaveManager.load_config("sfx_mute", "settings")
	var music_volume = SaveManager.load_config("music_volume", "settings")
	var sfx_volume = SaveManager.load_config("sfx_volume", "settings")

	if music_mute == null:
		music_mute = false
		SaveManager.save_config(music_mute, "music_mute", "settings")
	if sfx_mute == null:
		sfx_mute = false
		SaveManager.save_config(sfx_mute, "sfx_mute", "settings")
	if music_volume == null:
		music_volume = 0.0
		SaveManager.save_config(music_volume, "music_volume", "settings")
	elif music_volume < -100.0 or music_volume > 100.0:
		music_volume = clampf(music_volume, -100.0, 100.0)
		SaveManager.save_config(music_volume, "music_volume", "settings")
	if sfx_volume == null:
		sfx_volume = 0.0
		SaveManager.save_config(sfx_volume, "sfx_volume", "settings")
	elif sfx_volume < -100.0 or sfx_volume > 100.0:
		sfx_volume = clampf(sfx_volume, -100.0, 100.0)
		SaveManager.save_config(sfx_volume, "sfx_volume", "settings")

	AudioServer.set_bus_mute(music_bus, music_mute)
	AudioServer.set_bus_mute(sfx_bus, sfx_mute)
	AudioServer.set_bus_volume_db(music_bus, music_volume)
	AudioServer.set_bus_volume_db(sfx_bus, sfx_volume)
