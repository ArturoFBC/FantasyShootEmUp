class_name LevelLoader
extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var level = GlobalData.level_list[GlobalData.current_level_index].level_scene.instantiate()
	get_tree().root.add_child(level)
