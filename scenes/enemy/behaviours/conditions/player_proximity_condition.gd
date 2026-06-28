class_name  PlayerProximityCondition
extends BaseCondition

@export var detect_radious: float = 6.0
@export var collision: CollisionShape3D

func _ready() -> void:
	## Set detection radious
	collision.scale = Vector3.ONE * detect_radious


func _start_internal() -> void:
	collision.process_mode = Node.PROCESS_MODE_INHERIT


func _on_body_entered(body:Node3D) -> void:
	for child in body.get_children():
		if (child is PlayerHitPoints):
			condition_met.emit()


func _end_internal() -> void:
	collision.process_mode = Node.PROCESS_MODE_DISABLED
