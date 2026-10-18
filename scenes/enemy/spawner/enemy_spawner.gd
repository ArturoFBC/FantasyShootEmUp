class_name EnemySpawner
extends VisibleOnScreenEnabler3D

@export var spawn_points: Array[EnemySpawnPoint]

var _spawned := false


func _ready() -> void:
	if spawn_points == null || spawn_points.is_empty():
		for child in get_children():
			if child is EnemySpawnPoint:
				spawn_points.append(child)

	GlobalData.game_manager.level_state_changed.connect(_on_level_state_changed)
	if GlobalData.game_manager.get_current_state() == LevelManager.LevelState.InGame:
		_on_level_state_changed(LevelManager.LevelState.None, LevelManager.LevelState.InGame)


func _exit_tree() -> void:
	if GlobalData.game_manager and GlobalData.game_manager.level_state_changed.is_connected(_on_level_state_changed):
		GlobalData.game_manager.level_state_changed.disconnect(_on_level_state_changed)


func _on_level_state_changed(_prev_state: LevelManager.LevelState, new_state: LevelManager.LevelState) -> void:
	if new_state == LevelManager.LevelState.InGame and is_on_screen():
		_spawn()


func _on_screen_entered() -> void:
	if GlobalData.game_manager.get_current_state() != LevelManager.LevelState.InGame:
		return
	_spawn()


func _spawn() -> void:
	if _spawned:
		return
	_spawned = true

	for spawn_point: EnemySpawnPoint in spawn_points:
		var enemy := spawn_point.enemy_scene.instantiate()
		get_tree().current_scene.add_child(enemy)
		enemy.global_position = spawn_point.global_position
		enemy.global_rotation = spawn_point.global_rotation

	queue_free()
