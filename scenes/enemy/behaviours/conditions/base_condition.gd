class_name BaseCondition
extends Node

var root_node: Node3D

signal condition_met()


func _initialize(root: Node3D) -> void:
	root_node = root


func _start() -> void :
	process_mode = Node.PROCESS_MODE_INHERIT
	_start_internal()
	

func _start_internal() -> void:
	pass


func _end() -> void :
	process_mode = Node.ProcessMode.PROCESS_MODE_DISABLED
	_end_internal()
	

func _end_internal() -> void:
	pass
