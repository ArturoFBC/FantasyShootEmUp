class_name LevelTimer
extends Node

var elapsed_time : float = 0


func _process(delta: float) -> void:
	elapsed_time += delta
	
	
func _get_time() -> float:
	return elapsed_time
