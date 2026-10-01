extends MarginContainer

@onready var continue_button: Button = $CenterContainer/menu/continue
@onready var version: Label = $version

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	continue_button.grab_focus()
	version.text = ProjectSettings.get_setting("application/config/version")

	var path = "user://saves/savegame_%s.save" % GlobalVars.save_slot

	continue_button.disabled = !FileAccess.file_exists(path)



func _on_continue_pressed() -> void:
	SaveManager.load_save()


func _on_new_game_pressed() -> void:
	DirAccess.remove_absolute("user://saves/savegame_%s.save" % GlobalVars.save_slot)
	TransitionManager.transition("res://scenes/test_env.tscn")


func _on_load_pressed() -> void:
	pass


func _on_settings_pressed() -> void:
	pass


func _on_exit_pressed() -> void:
	get_tree().quit()
