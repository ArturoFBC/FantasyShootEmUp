class_name InGameUI
extends Node


@export var intro_screen : Control 
@export var victory_screen : Control
@export var defeat_screen : Control 
@export var pause_menu : Control 


func _ready() -> void:
	GlobalData.game_manager.level_state_changed.connect(_on_level_state_changed)
	var current_state = GlobalData.game_manager.get_current_state()
	if current_state != LevelManager.LevelState.None:
		_on_level_state_changed(LevelManager.LevelState.None, current_state)


func _exit_tree() -> void:
	if GlobalData.game_manager.level_state_changed.is_connected(_on_level_state_changed):
		GlobalData.game_manager.level_state_changed.disconnect(_on_level_state_changed)
		
		
func _on_level_state_changed(prev_state: LevelManager.LevelState, new_state: LevelManager.LevelState) -> void:
	match new_state:
		LevelManager.LevelState.Intro:
			intro_screen.show()
		LevelManager.LevelState.InGame:
			if prev_state == LevelManager.LevelState.Intro:
				intro_screen.hide()
