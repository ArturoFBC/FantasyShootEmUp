class_name FlickerOnDamage
extends Node

@export var my_hit_points: HitPoints
@export var my_mesh: Node3D
@export var flash_time: float = 0.3
@export var flash_interval: float = 0.05

func _ready() -> void:
	## Find references
	if my_hit_points == null:
		for sibling in get_parent().get_children():
			if sibling is HitPoints:
				my_hit_points = sibling
				break
				
	my_hit_points.damage_received.connect(on_damage_received)


func _exit_tree() -> void:
	my_hit_points.damage_received.disconnect(on_damage_received)


func on_damage_received(damage: float, previous_hp: float, max_hp: float) -> void:
	var current_time = 0.0
	while current_time < flash_time:
		current_time += flash_interval
		my_mesh.visible = !my_mesh.visible
		await get_tree().create_timer(flash_interval).timeout
	
	my_mesh.visible = true
