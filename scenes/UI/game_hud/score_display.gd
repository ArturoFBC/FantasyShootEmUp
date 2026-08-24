class_name ScoreDisplay
extends Label

@export var score_resource:ScoreResource
var current_score: float


func _ready():
	score_resource.score_updated.connect(_on_score_updated)
	_on_score_updated(current_score, score_resource.get_score())
	

func _on_score_updated(_previous_score: float, new_score: float):
	current_score = new_score
	text = "%d" % current_score


func _exit_tree() -> void:
	score_resource.score_updated.disconnect(_on_score_updated)
