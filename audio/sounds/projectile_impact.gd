class_name Projectile_Impact
extends Node3D

@export var soft_sound: AudioStreamRandomizer
@export var soft_volume: int = -8
@export var hard_sound: AudioStreamRandomizer
@export var hard_volume: int = -15
@export var stream_player_scene: PackedScene


func _on_area_3d_impact(surface_type: Projectile.CollisionSurfaceType) -> void:
	var stream_player := stream_player_scene.instantiate()
	get_tree().current_scene.add_child(stream_player)
	stream_player.global_position = global_position
	
	match surface_type:
		Projectile.CollisionSurfaceType.soft:
			stream_player.stream = soft_sound
			stream_player.volume_db = soft_volume
		Projectile.CollisionSurfaceType.hard:
			stream_player.stream = hard_sound
			stream_player.volume_db = hard_volume
			
	stream_player.play()
