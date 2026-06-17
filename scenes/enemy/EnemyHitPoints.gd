class_name EnemyHitPoints
extends HitPoints


func _take_damage(damage: float) -> void:
	if (damage >= current_hp):
		current_hp = 0
		_die()
	else:
		current_hp -= damage


func _die() -> void:
	get_parent().queue_free()
