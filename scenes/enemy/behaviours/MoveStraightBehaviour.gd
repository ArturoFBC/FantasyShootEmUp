extends Node

@export var speed: float = 6.0

@onready var root_node = get_parent()


func _process(delta: float) -> void:
	root_node.position += root_node.basis.z * speed * delta
