extends Area2D

@onready var inv: InvNode = $"../Camera2D/CanvasLayer/inv"
var items: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and items.size() >= 1:
		inv.add_item(items[0].get_item())
		items[0].kill()
		print("yay")


func _on_area_entered(area: Area2D) -> void:
	match area.get_collision_layer():
		64:
			items.append(area)
	


func _on_area_exited(area: Area2D) -> void:
	match area.get_collision_layer():
		64:
			items.erase(area)
