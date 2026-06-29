class_name EnemyBehavioursManager
extends Node


@export var states: Array[State]
var current_state: int = 0


func _ready() -> void:
	var root_node = get_parent()
	for state in states:
		state.behaviour._initialize(root_node)
		state.condition._initialize(root_node)
	
	start_state(current_state)


func _on_condition_met() -> void:
	end_state(current_state)
	
	if current_state + 1 >= states.size():
		current_state = 0
	else:
		current_state += 1
		
	start_state(current_state)


func start_state(state: int) -> void:
	states[state].behaviour._start()
	states[state].condition._start()
	states[state].condition.condition_met.connect(_on_condition_met)


func end_state(state: int) -> void:
	states[state].behaviour._end()
	states[state].condition._end()
	states[state].condition.condition_met.disconnect(_on_condition_met)
