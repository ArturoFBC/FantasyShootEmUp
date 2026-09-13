class_name EnemySpawner
extends VisibleOnScreenEnabler3D

@export var spawn_points: Array[EnemySpawnPoint]

func _ready() -> void:
	if spawn_points == null || spawn_points.is_empty():
		for child in get_children():
			if child is EnemySpawnPoint:
				spawn_points.append(child)
			

func _on_screen_entered() -> void:
	for spawn_point: EnemySpawnPoint in spawn_points:
		var enemy := spawn_point.enemy_scene.instantiate()
		get_tree().current_scene.add_child(enemy)
		enemy.global_position = spawn_point.global_position
		enemy.global_rotation = spawn_point.global_rotation
		
	queue_free()
