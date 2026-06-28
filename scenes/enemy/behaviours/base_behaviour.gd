class_name BaseBehaviour
extends Node

@export var auto_start: bool = false
var root_node: Node3D


func _ready() -> void:
	if auto_start:
		_start()


func _initialize(root: Node3D) -> void:
	root_node = root


func _start() -> void :
	print("Start " + name)
	process_mode = Node.PROCESS_MODE_INHERIT
	_start_internal()
	

func _start_internal() -> void:
	pass


func _end() -> void :
	process_mode = Node.ProcessMode.PROCESS_MODE_DISABLED
	_end_internal()
	

func _end_internal() -> void:
	pass
