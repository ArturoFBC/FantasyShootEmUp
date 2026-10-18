class_name VictoryScreen
extends EndGameScreen


func _on_continue_button_pressed() -> void:
	GlobalData.current_level_index += 1
	if GlobalData.current_level_index < GlobalData.level_list.size():
		get_tree().change_scene_to_file(ScenePaths.IN_GAME)
	else:
		get_tree().change_scene_to_file(ScenePaths.TITLE)
