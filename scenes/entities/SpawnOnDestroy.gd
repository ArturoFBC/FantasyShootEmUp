class_name SpawnOnDestroy
extends Node

@export var scene_to_spawn: PackedScene

@onready var root_node: Node3D = get_parent()

func _on_destroyed() -> void:
	var object := scene_to_spawn.instantiate()
	get_tree().current_scene.add_child(object)
	object.position = root_node.position
	object.rotation = root_node.rotation
