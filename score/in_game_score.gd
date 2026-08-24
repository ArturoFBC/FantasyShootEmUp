class_name InGameScore
extends Node

@export var score_resource:ScoreResource

func _ready() -> void:
	score_resource.reset()
