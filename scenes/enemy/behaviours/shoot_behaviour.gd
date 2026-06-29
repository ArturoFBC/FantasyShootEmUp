class_name ShootBehaviour
extends BaseBehaviour

@export var weapon : Weapon


func _start_internal() -> void:
	weapon.process_mode = Node.PROCESS_MODE_INHERIT

func _end_internal() -> void:
	weapon.process_mode = Node.PROCESS_MODE_DISABLED
