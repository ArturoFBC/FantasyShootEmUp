class_name PlayerHitPoints
extends HitPoints


func _ready():
	SignalBus.emit_signal("player_maxHP_updated", max_hp, max_hp)
	SignalBus.emit_signal("player_HP_updated", current_hp, current_hp)
	

func _damage_effects(damage: float, previous_hp: float) -> void:
	damage_received.emit(damage, current_hp, max_hp)
	SignalBus.emit_signal("player_HP_updated", current_hp, previous_hp)


func _on_power_up_catcher_health_picked_up(amount: float) -> void:
	current_hp = minf(max_hp, current_hp + amount)
