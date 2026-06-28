class_name ForwardMoveBehaviour
extends BaseBehaviour

@export var advance_speed: float = 6.0


func _process(delta: float) -> void:
	if root_node != null:
		root_node.position += root_node.basis.z * advance_speed * delta
