class_name PlayerHitPoints
extends HitPoints


func _ready():
	SignalBus.emit_signal("player_maxHP_updated", max_hp, max_hp)
	SignalBus.emit_signal("player_HP_updated", current_hp, current_hp)
	

func _take_damage(damage: float) -> void:
	var previous_hp = current_hp
	if (damage >= current_hp):
		current_hp = 0
		_die()
	else:
		current_hp -= damage
	SignalBus.emit_signal("player_HP_updated", current_hp, previous_hp)


func _die() -> void:
	get_parent().queue_free()
