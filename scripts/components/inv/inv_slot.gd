extends Control
class_name InvSlot

@export var slot: Slot = Slot.new()
@export var equipment: bool
@export_enum("consumable", "weapon", "usable", "misc") var type

@onready var bg: InvSlot = $"."
@onready var rarity: TextureRect = $rarity
@onready var item_texture: TextureRect = $item
@onready var label: Label = $Label
@onready var tooltip: TextureRect = $tooltip

signal item_changed

func _get_drag_data(at_position: Vector2) -> Variant:
	if !slot or slot.item == null:
		return

	var item = slot.item
	var amount = slot.amount
	 
	var preview = Control.new()
	preview.add_child(rarity.duplicate())
	preview.add_child(item_texture.duplicate())
	preview.add_child(label.duplicate())
	preview.position -= Vector2(25, 25)
	preview.self_modulate = Color(preview.modulate, 0.5)

	set_drag_preview(preview)
	return slot

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if type:
		return data.item.type == type
	else:
		return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if !slot or (slot.item == null and slot.amount == 0):
		slot.amount = data.amount
		slot.item = data.item
		data.amount = 0
		data.item = null
	else:
		if slot.item == data.item:
			slot.amount += data.amount
		else:
			var new_amount = data.amount
			var new_item = data.item
			data.amount = slot.amount
			data.item = slot.item
			slot.amount = new_amount
			slot.item = new_item
			
	populate()
	

func populate():
	if slot.item != null:
		var item = slot.item
		var amount = slot.amount
		item_changed.emit(item, amount)
		item_texture.texture = item.icon
		rarity.texture = load(GlobalAssets.rarities[item.rarity])
		item_texture.visible = true
		label.visible = true
		rarity.visible = true
		tooltip.visible = false
		if not equipment:
			label.text = str(amount)
		else:
			label.visible = false
	else:
		tooltip.visible = true
		item_texture.visible = false
		label.visible = false
		rarity.visible = false
		item_changed.emit(false)

func _ready() -> void:
	populate()
	add_to_group("slot")

func _process(delta: float) -> void:
	populate()

func clear():
	slot.amount = 0
	slot.item = null
