class_name PowerUpCatcher
extends Node


signal power_up_main_grabbed()
signal power_up_secondary_grabbed()
signal health_picked_up(amount: float)



func _power_up_catched(type: PowerUp.PowerUpType, amount: float):
	match(type):
		PowerUp.PowerUpType.main_weapon:
			power_up_main_grabbed.emit()
		PowerUp.PowerUpType.secondary_weapon:
			power_up_secondary_grabbed.emit()
		PowerUp.PowerUpType.health:
			health_picked_up.emit(amount)
