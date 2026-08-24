class_name LevelManager
extends Node

enum LevelState
{
	None,
	Intro,
	InGame,
	Paused,
	Outro
}

enum VictoryState
{
	Undecided,
	Victory,
	Defeat
}
enum PauseRequest
{
	NoRequest,
	PauseRequested,
	UnpauseRequested
}

signal level_state_changed(prev_state: LevelState, new_state: LevelState)


var current_state: LevelState = LevelState.Intro
var prev_state: LevelState = LevelState.None
@export var intro_duration: float = 3
var intro_timer: SceneTreeTimer
var victory: VictoryState
var pause_requested: PauseRequest


func _init() -> void:
	GlobalData.game_manager = self
	prev_state = LevelState.None
	current_state = LevelState.Intro


func _process(_delta: float) -> void:
	var next_state = current_state
	match current_state:
		LevelState.Intro:
			if prev_state != current_state:
				on_enter_intro()
			next_state = intro_get_next_state()
			if current_state != next_state:
				on_exit_intro_state();
				go_to_state(next_state)
		LevelState.InGame:
			if prev_state != current_state:
				on_enter_ingame()
			next_state = ingame_get_next_state()
			if current_state != next_state:
				on_exit_ingame_state();
				go_to_state(next_state)
		LevelState.Paused:
			if prev_state != current_state:
				on_enter_paused()
			next_state = pause_get_next_state()
			if current_state != next_state:
				on_exit_paused_state();
				go_to_state(next_state)
		LevelState.Outro:
			if prev_state != current_state:
				on_enter_outro()

	prev_state = current_state


func go_to_state(new_state: LevelState) -> void:
	prev_state = current_state
	current_state = new_state
	print("GAME STATE ", prev_state, " -> " ,new_state)
	level_state_changed.emit(prev_state, new_state)


#region INTRO
func on_enter_intro() -> void:
	intro_timer = get_tree().create_timer(intro_duration, true, false, false)


func intro_get_next_state() -> LevelState:
	if intro_timer.time_left == 0:
		return LevelState.InGame
	return LevelState.Intro


func on_exit_intro_state() -> void:
	intro_timer = null
#endregion


#region INGAME
func on_enter_ingame() -> void:
	pause_requested = PauseRequest.NoRequest


func ingame_get_next_state() -> LevelState:
	if victory != VictoryState.Undecided:
		return LevelState.Outro
	if pause_requested == PauseRequest.PauseRequested:
		return LevelState.Paused
		
	return LevelState.InGame


func on_exit_ingame_state() -> void:
	pause_requested = PauseRequest.NoRequest
#endregion


#region PAUSED
func on_enter_paused() -> void:
	pause_requested = PauseRequest.NoRequest


func pause_get_next_state() -> LevelState:
	if pause_requested == PauseRequest.UnpauseRequested:
		return LevelState.InGame
		
	return LevelState.Paused


func on_exit_paused_state() -> void:
	pause_requested = PauseRequest.NoRequest
#endregion


#region OUTRO
func on_enter_outro() -> void:
	return
#endregion


func request_pause() -> void:
	pause_requested = PauseRequest.PauseRequested


func request_unpause() -> void:
	pause_requested = PauseRequest.UnpauseRequested


func end_level_reached() -> void:
	victory = VictoryState.Victory


func player_is_dead() -> void:
	victory = VictoryState.Defeat


func get_current_state() -> LevelState:
	return current_state
