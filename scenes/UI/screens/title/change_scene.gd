extends Node

@export var target: ScenePaths.Id


func _on_pressed() -> void:
	get_tree().change_scene_to_file(ScenePaths.path(target))
