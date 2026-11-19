class_name HitParticleSpawner
extends Node

## Particle scene to instantiate when the parent lance damages an enemy.
@export var particle_scene: PackedScene

## Whether to also spawn particles on damage_started (initial hit).
@export var spawn_on_start: bool = true

func _ready() -> void:
	var parent: Node = get_parent()
	if parent.has_signal("damage_tick") && parent.damage_tick.is_connected(_on_damage_tick) == false :
		parent.damage_tick.connect(_on_damage_tick)
	if spawn_on_start and parent.has_signal("damage_started"):
		parent.damage_started.connect(_on_damage_started)

func _on_damage_tick(enemy: EnemyHitPoints, contact_position: Vector3) -> void:
	if particle_scene == null or enemy == null:
		return
	var particles = particle_scene.instantiate()
	get_tree().current_scene.add_child(particles)
	particles.global_position = contact_position
	# Force a fresh one-shot burst regardless of saved emitting state
	particles.emitting = false
	particles.emitting = true


func _on_damage_started() -> void:
	# Spawn an initial burst when damage first begins.
	# We don't have enemy data here, so this is a placeholder for any
	# start-of-damage visual the subclass might want.
	pass
