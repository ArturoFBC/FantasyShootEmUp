class_name PowerUp
extends Area3D

enum PowerUpType
{
	main_weapon,
	secondary_weapon,
	health
}

@export var type: PowerUpType
@export var amount: float = 20


func _ready() -> void:
	if body_entered.is_connected(_on_body_entered) == false:
		body_entered.connect(_on_body_entered)


func _on_body_entered(body:Node3D) -> void:
	for child in body.get_children():
		if (child is PowerUpCatcher):
			child._power_up_catched(type, amount)
			queue_free()
