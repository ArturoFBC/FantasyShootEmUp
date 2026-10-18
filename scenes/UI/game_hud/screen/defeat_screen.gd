class_name DefeatScreen
extends EndGameScreenBase


func _on_continue_button_pressed() -> void:
	get_tree().change_scene_to_file(IN_GAME_SCENE)
