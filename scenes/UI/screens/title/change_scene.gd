extends Node

@export var new_scene: PackedScene


func _on_pressed() -> void:
	get_tree().change_scene_to_packed(new_scene)
