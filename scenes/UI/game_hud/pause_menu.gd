class_name PauseMenu
extends Control


func _ready() -> void:
	hide()


func _on_resume_button_pressed() -> void:
	if GlobalData.game_manager:
		GlobalData.game_manager.request_unpause()


func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file(ScenePaths.TITLE)
