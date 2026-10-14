extends Node2D
class_name ItemDropper

@export var bundle := true
@export var spread := Vector2(1, 1)
@export var parent : Node2D

var random = RandomNumberGenerator.new()

func drop(items: Array[Slot]):
	for slot in items:
		if bundle:
			_drop_item(slot)
		else:
			for i in range(slot.amount):
				var new_slot = Slot.new()
				new_slot.amount = 1
				new_slot.item = slot.item
				_drop_item(slot)

func _drop_item(slot: Slot):
	var random_spread_x = randf_range(1, spread.x)
	var random_spread_y = randf_range(1, spread.y)
	var new_item_node = load("scenes/prefabs/item_node.tscn").instantiate()
	new_item_node.item = slot
	new_item_node.position = Vector2(parent.position.x * random_spread_x, parent.position.y * random_spread_y)
	get_tree().root.add_child(new_item_node)
