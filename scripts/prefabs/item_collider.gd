extends Area2D

@onready var item: RigidBody2D = $".."
@onready var bg: AnimatedSprite2D = $"../bg"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_item():
	return item.item

func kill():
	print("kill")
	$"CollisionShape2D".disabled = true
	bg.play("despawn")
