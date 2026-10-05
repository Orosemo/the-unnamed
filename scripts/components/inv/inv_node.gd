extends Control
class_name InvNode

@export var inv: Dictionary[String, InvSpace]

var state: Dictionary


func save() -> Dictionary:
	var inv_data := {}

	for space_id in inv:
		var space: InvSpace = inv[space_id]

		inv_data[space_id] = {
			"size": space.space_size,
			"Array": []
		}
		inv_data[space_id]["Array"].resize(space.space_size)

		for i in range(space.inv_slots.size()):
			var inv_slot: InvSlot = space.inv_slots[i]

			if inv_slot == null:
				continue

			if inv_slot.slot == null:
				continue

			if inv_slot.slot.amount <= 0:
				continue

			var item_data = {
				"amount": inv_slot.slot.amount,
				"item": inv_slot.slot.item.resource_path
			}

			# determines saving location
			if space.generate:
				inv_data[space_id]["Array"][i] = item_data

	return inv_data


func load_inv(inv_data: Dictionary):
	for space_id in inv_data:
		if !inv.has(space_id):
			push_error("Inventory space '%s' not found." % space_id)
			continue

		var space: InvSpace = inv[space_id]

		if space.generate:
			for slot_node: InvSlot in space.inv_slots:
				slot_node.queue_free()
			space.inv_slots.clear()

			var saved_array: Array = inv_data[space_id].get("Array", [])
			var slot_count: int = max(space.space_size, saved_array.size())

			for i in slot_count:
				var slot_node = preload("res://scenes/prefabs/inv_slot.tscn").instantiate()
				slot_node.generated_slot = true

				if i < saved_array.size() and saved_array[i] != null:
					var slot_data: Dictionary = saved_array[i]

					var slot_res := Slot.new()
					slot_res.amount = slot_data["amount"]
					slot_res.item = load(slot_data["item"])

					slot_node.slot = slot_res

				# for empty slots
				else:
					var slot_res := Slot.new()
					slot_node.slot = slot_res

				slot_node.add_to_group("slot")
				space.add_child(slot_node)
				space.inv_slots.append(slot_node)
