class_name ActivateNodeOnGameState
extends Node

@export var target: Node
@export var expected_state: LevelManager.LevelState = LevelManager.LevelState.InGame
@export var activation_or_deactivation: bool = true
@export var flip_on_state_exit: bool = true


func _ready() -> void:
	GlobalData.game_manager.level_state_changed.connect(_on_level_state_changed)
	var current_state = GlobalData.game_manager.get_current_state()
	if current_state != LevelManager.LevelState.None:
		_on_level_state_changed(LevelManager.LevelState.None, current_state)


func _exit_tree() -> void:
	if GlobalData.game_manager.level_state_changed.is_connected(_on_level_state_changed):
		GlobalData.game_manager.level_state_changed.disconnect(_on_level_state_changed)


func _on_level_state_changed(prev_state: LevelManager.LevelState, new_state: LevelManager.LevelState) -> void:
	if new_state == expected_state:
		if activation_or_deactivation:
			target.process_mode = Node.PROCESS_MODE_INHERIT
		else:
			target.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		if flip_on_state_exit:
			if activation_or_deactivation:
				target.process_mode = Node.PROCESS_MODE_DISABLED
			else:
				target.process_mode = Node.PROCESS_MODE_INHERIT
				
