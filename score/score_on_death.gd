class_name ScoreOnDeath
extends Node

@onready var my_hit_points: EnemyHitPoints = %EnemyHitPoints
@export var score_granted:float = 100
@export var score_resource:ScoreResource

func _ready() -> void:
	_connect_to_death_event()
	
	
func _connect_to_death_event() -> void:
	if my_hit_points == null:
		for child in get_parent().get_children():
			if child is EnemyHitPoints:
				my_hit_points = child

	if my_hit_points == null:
		push_warning("Score on death can not find EnemyHitPoints to connect to death signal")
		return;
		
	my_hit_points.death.connect(_grant_score_on_death)
	
	
func _grant_score_on_death() -> void:
	score_resource.add_score(score_granted)
	if my_hit_points != null:
		my_hit_points.death.disconnect(_grant_score_on_death)
