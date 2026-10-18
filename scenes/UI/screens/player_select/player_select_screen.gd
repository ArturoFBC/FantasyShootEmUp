class_name PlayerSelectScreen
extends Node

@export var class_list : ClassList


func _on_knight_button_up() -> void:
	GlobalData.current_character_class = class_list.list[0]
	get_tree().change_scene_to_file(ScenePaths.IN_GAME)


func _on_barbarian_button_up() -> void:
	GlobalData.current_character_class = class_list.list[1]
	get_tree().change_scene_to_file(ScenePaths.IN_GAME)
