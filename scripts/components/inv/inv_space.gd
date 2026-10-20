extends Container
class_name InvSpace

@export var inv_slots: Array[InvSlot]
@export var space_size : int
@export var expanding: bool

@onready var status_message_box = $"../../../../../hud/StatusMessageBox"
@onready var item_dropper: ItemDropper = $"../../../../../../../ItemDropper"

func _ready() -> void:
	if !expanding:
		_create_generated_slots(space_size)

func _create_generated_slots(slot_count: int) -> void:
	while inv_slots.size() < slot_count:
		var new_slot: InvSlot = preload("res://scenes/prefabs/inv_slot.tscn").instantiate()
		add_child(new_slot)
		inv_slots.append(new_slot)

func add(item: Slot):
	print("yay3")
	var index = inv_slots.find_custom(func(slot): return slot.slot.amount == 0)
	if expanding:
		if index != -1:
			inv_slots[index].slot = item
			inv_slots[index].populate()
			inv_slots[index].item_dropper = item_dropper
			print("item:")
			print(item)
			return
		else:
			var new_slot: InvSlot = preload("res://scenes/prefabs/inv_slot.tscn").instantiate()
			new_slot.slot = item
			new_slot.item_dropper = item_dropper
			add_child(new_slot)
			inv_slots.append(new_slot)
			space_size = inv_slots.size()
	elif !expanding:
		inv_slots[index].slot = item
		inv_slots[index].item_dropper = item_dropper
		space_size = inv_slots.size()
	else:
		status_message_box.add_message("NO SPACE")
