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
	
	damage_received.emit(damage, current_hp, max_hp)
	_damage_taken(damage, previous_hp)


func _damage_taken(_damage: float, _previous_hp: float) -> void:
	return


func _die() -> void:
	death.emit()
	get_parent().queue_free()
