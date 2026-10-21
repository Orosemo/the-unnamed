extends Node

func save():

	if not GlobalVars.save_slot:
		return

	var path = "user://saves/savegame_%s.save" % GlobalVars.save_slot

	var dir = DirAccess.open("user://")

	if not dir.dir_exists("saves"):
		dir.make_dir("saves")

	var current_save_file = FileAccess.open(path, FileAccess.WRITE)
	
	current_save_file.store_string("")
	current_save_file.close()

	var save_file = FileAccess.open(path, FileAccess.WRITE)

	var save_nodes = get_tree().get_nodes_in_group("Persist")

	# create header with current root scene path
	var header = {
		"header": true,
		"scene": get_tree().current_scene.scene_file_path,
	}

	# store header
	save_file.store_line(JSON.stringify(header))

	print(header)

	# check all save nodes
	for node in save_nodes:

		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		if not node.has_method("save"):
			print("persistent node '%s' missing save()" % node.name)
			continue

		# save stuff ig
		var node_data = node.save()

		node_data["parent"] = get_tree().current_scene.get_path_to(node.get_parent())
		node_data["name"] = get_tree().current_scene.get_path_to(node)

		save_file.store_line(JSON.stringify(node_data))

		print(node_data)

	print("save success")
	


func load_save():

	if !GlobalVars.save_slot:
		return

	var path = "user://saves/savegame_%s.save" % GlobalVars.save_slot

	if !FileAccess.file_exists(path):
		print("No save found")
		return

	var save_file = FileAccess.open(path, FileAccess.READ)

	var header = JSON.parse_string(save_file.get_line())

	if header == null or !header.has("header"):
		print("Invalid save")
		return

	TimeManager.play()
	var result = get_tree().change_scene_to_file(header["scene"])

	if result != OK:
		print("Could not load scene:", header["scene"])
		return

	# wait 2x !!
	await get_tree().process_frame
	await get_tree().process_frame

	# check scene
	var scene = get_tree().current_scene

	if scene == null:
		print("Current scene is still null")
		return

	# go through save file
	while save_file.get_position() < save_file.get_length():

		var line = save_file.get_line()

		if line.is_empty():
			continue

		var node_data = JSON.parse_string(line)

		if node_data == null:
			continue

		var parent = scene.get_node_or_null(node_data["parent"])

		if parent == null:
			print("Parent missing:", node_data["parent"])
			continue

		# populate exsisting scene/node
		print(node_data)
		var existing = parent.get_node_or_null(node_data["name"])

		if existing:
			if existing.has_method("load_data"):
				existing.load_data(node_data)
			continue

		# load new scene
		var packed_scene = load(node_data["filename"])

		if packed_scene == null:
			print("Missing scene:", node_data["filename"])
			continue

		var new_object = packed_scene.instantiate()
		new_object.name = node_data["name"]

		parent.add_child(new_object)

		if new_object.has_method("load_data"):
			new_object.load_data(node_data)

	# yay
	print("Load success")
	TimeManager.play()
	save_file.close()




func save_config(value, name:String, section:String):

	var config = ConfigFile.new()

	config.set_value(section, name, value)

	config.save("user://config.cfg")




func load_config(name:String, section:String):

	var config = ConfigFile.new()

	var err = config.load("user://config.cfg")

	if err != OK:
		return null


	return config.get_value(section, name)
