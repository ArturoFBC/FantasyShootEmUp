class_name VictoryScreen
extends EndGameScreenBase


func _on_continue_button_pressed() -> void:
	GlobalData.current_level_index += 1
	if GlobalData.current_level_index < GlobalData.level_list.size():
		get_tree().change_scene_to_file(IN_GAME_SCENE)
	else:
		get_tree().change_scene_to_file(TITLE_SCENE)
