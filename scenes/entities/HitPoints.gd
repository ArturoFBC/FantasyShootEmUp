class_name HitPoints
extends CollisionShape3D

signal damage_received(damage: float, current_hp: float, max_hp: float)
signal death()

@export var max_hp: float = 100

@onready var current_hp: float = max_hp


func _take_damage(damage: float) -> void:
	var previous_hp = current_hp
	if (damage >= current_hp):
		current_hp = 0
		_die()
	else:
		current_hp -= damage
		
	_damage_effects(damage, previous_hp)


func _die() -> void:
	death.emit()
	get_parent().queue_free()
	
	
func _damage_effects(damage: float, previous_hp: float) -> void:
	pass
