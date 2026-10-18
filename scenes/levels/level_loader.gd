class_name LevelLoader
extends Node

@export var level_parent: Node


func _ready() -> void:
	var level = GlobalData.level_list[GlobalData.current_level_index].level_scene.instantiate()
	level_parent.add_child.call_deferred(level)
