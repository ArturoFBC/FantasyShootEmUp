class_name PowerUpCatcher
extends Node


func _power_up_catched(type: PowerUp.PowerUpType, amount: float):
	match(type):
		PowerUp.PowerUpType.main_weapon:
			SignalBus.emit_signal("power_up_main_grabbed")
		PowerUp.PowerUpType.secondary_weapon:
			SignalBus.emit_signal("power_up_secondary_grabbed")
		PowerUp.PowerUpType.health:
			SignalBus.emit_signal("health_picked_up", amount)
