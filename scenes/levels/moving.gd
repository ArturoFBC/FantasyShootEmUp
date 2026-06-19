extends Node3D

@export var direction: Vector3 = Vector3(0,0,-1)


func _physics_process(delta: float) -> void:
	position += direction * delta
