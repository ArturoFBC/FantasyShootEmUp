class_name EndOfLevel
extends VisibleOnScreenEnabler3D

var _reached := false


func _ready() -> void:
	GlobalData.game_manager.level_state_changed.connect(_on_level_state_changed)
	if GlobalData.game_manager.get_current_state() == LevelManager.LevelState.InGame:
		_on_level_state_changed(LevelManager.LevelState.None, LevelManager.LevelState.InGame)


func _exit_tree() -> void:
	if GlobalData.game_manager and GlobalData.game_manager.level_state_changed.is_connected(_on_level_state_changed):
		GlobalData.game_manager.level_state_changed.disconnect(_on_level_state_changed)


func _on_level_state_changed(_prev_state: LevelManager.LevelState, new_state: LevelManager.LevelState) -> void:
	if new_state == LevelManager.LevelState.InGame and is_on_screen():
		_end_level()


func _on_screen_entered() -> void:
	if GlobalData.game_manager.get_current_state() != LevelManager.LevelState.InGame:
		return
	_end_level()


func _end_level() -> void:
	if _reached:
		return
	_reached = true
	GlobalData.game_manager.end_level_reached()
	queue_free()
