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
	if expanding:
		var new_slot: InvSlot = preload("res://scenes/prefabs/inv_slot.tscn").instantiate()
		new_slot.slot = item
		new_slot.item_dropper = item_dropper
		add_child(new_slot)
		inv_slots.append(new_slot)
		space_size = inv_slots.size()
	elif !expanding and inv_slots.size() < space_size:
		var position = inv_slots.find(null)
		inv_slots[position] = InvSlot.new()
		inv_slots[position].slot = item
		inv_slots[position].item_dropper = item_dropper
		space_size = inv_slots.size()
	else:
		status_message_box.add_message("NO SPACE")
