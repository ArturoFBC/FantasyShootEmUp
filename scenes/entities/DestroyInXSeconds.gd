extends Node

@export var seconds: float = 1.0


func _ready() -> void:
	await get_tree().create_timer(seconds).timeout
	get_parent().queue_free()
