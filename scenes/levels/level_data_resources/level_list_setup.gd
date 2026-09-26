class_name LevelListSetup
extends Node

@export var level_list : LevelList

func _ready() -> void:
	GlobalData.level_list = level_list.level_list
	GlobalData.current_level_index = 0
