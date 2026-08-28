class_name EndOfLevel
extends Node


func _on_screen_entered() -> void:
	GlobalData.game_manager.end_level_reached()
	queue_free()
