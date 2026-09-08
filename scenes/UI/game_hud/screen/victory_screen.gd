class_name VictoryScreen
extends Control

@export var time_label: Label
@export var score_label: Label
@export var level_name_label: Label


func _display(time: float, score: float) -> void:
	time_label.text = "%4.2f" % time
	score_label.text = "%d" % score
	show()
