class_name EndGameScreenBase
extends Control

const IN_GAME_SCENE := "res://scenes/levels/in_game.tscn"
const TITLE_SCENE := "res://scenes/UI/screens/title/title.tscn"

@export var time_label: Label
@export var score_label: Label
@export var level_name_label: Label


func _display(time: float, score: float) -> void:
	time_label.text = "%4.2f" % time
	score_label.text = "%d" % score
	level_name_label.text = GlobalData.level_list[GlobalData.current_level_index].level_name
	show()


func _on_continue_button_pressed() -> void:
	pass


func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file(TITLE_SCENE)
