class_name DestroyAfterDistanceTraveled
extends Node

@export var max_range: float = 10.0

var current_distance_traveled: float = 0
var previous_position: Vector3 = Vector3.ZERO
var root_node: Node3D

var initialized: bool = false


func _ready() -> void:
	root_node = get_parent()
	current_distance_traveled = max_range


func _physics_process(delta: float) -> void:
	if initialized == false:
		previous_position = root_node.global_position
		initialized = true
		return
	
	current_distance_traveled -= root_node.global_position.distance_to(previous_position)
	previous_position = root_node.global_position
	if current_distance_traveled <= 0:
		root_node._destroy()
