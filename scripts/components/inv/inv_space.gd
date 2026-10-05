extends Container
class_name InvSpace

@export var inv_slots: Array[InvSlot]
@export var space_size : int

func _ready() -> void:
	_create_generated_slots(space_size)


func _create_generated_slots(slot_count: int) -> void:
	while inv_slots.size() < slot_count:
		var new_slot: InvSlot = preload("res://scenes/prefabs/inv_slot.tscn").instantiate()
		add_child(new_slot)
		inv_slots.append(new_slot)
