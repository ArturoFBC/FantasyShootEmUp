class_name DefeatScreen
extends EndGameScreen


func _on_continue_button_pressed() -> void:
	get_tree().change_scene_to_file(ScenePaths.IN_GAME)


func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file(ScenePaths.TITLE)
