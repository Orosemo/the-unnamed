extends RigidBody2D

@onready var bg: AnimatedSprite2D = $bg
@onready var item_node: Sprite2D = $item
@onready var light: PointLight2D = $light
@onready var label: Label = $amount
@onready var interact: Label = $interact

@export var item: Slot

func update():
	bg.sprite_frames = load(GlobalAssets.rarities_anim[item.item.rarity])
	item_node.texture = item.item.icon
	light.color = GlobalAssets.rarities_lights[item.item.rarity]
	label.text = str(item.amount)

func _ready() -> void:
	interact.visible = false
	if item:
		update()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_collision_layer() == 8:
		interact.visible = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_collision_layer() == 8:
		interact.visible = false


func _on_bg_animation_finished() -> void:
	queue_free()