class_name TimeCondition
extends BaseCondition

@export var time: float = 2

func _start_internal() -> void:
	await get_tree().create_timer(time).timeout
	_condition_met.emit()
