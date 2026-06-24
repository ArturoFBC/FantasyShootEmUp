extends Node

@export var scene_to_spawn: PackedScene


func _on_destroyed(position: Vector3, rotation: Vector3):
	var object := scene_to_spawn.instantiate()
	get_tree().current_scene.add_child(object)
	object.position = position
	object.rotation = rotation
