class_name NotifyLevelManagerOnDeath
extends Node


func _on_player_hit_points_death() -> void:
	GlobalData.game_manager.player_is_dead()
