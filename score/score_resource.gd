class_name ScoreResource
extends Resource

signal score_updated(previous_score:float, new_score:float)

var current_score: float


func add_score(added_score: float) -> void:
	var previous_score = current_score
	current_score = current_score + added_score
	score_updated.emit(previous_score, current_score)


func reset() -> void:
	current_score = 0
	score_updated.emit(0,0)


func get_score() -> float:
	return current_score
