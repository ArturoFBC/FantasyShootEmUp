class_name LanceProjectile
extends Area3D

signal destroyed()
signal damage_started()
signal damage_stopped()
signal damage_tick(enemy: EnemyHitPoints, contact_position: Vector3)

## Damage dealt per second to every enemy currently overlapping the lance.
@export var damage: float = 1.0
## How long the lance stays alive before disappearing.
@export var lifetime: float = 2.0
## How often to emit damage_tick for particle/spawn effects (seconds).
@export var particle_tick_interval: float = 0.1

var overlapping_enemies: Array[EnemyHitPoints] = []
var was_damaging: bool = false
var particle_timer: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

## Initialize the lance when spawned as a child of a spawn point.
func init(new_damage: float) -> void:
	damage = new_damage

## Called every physics iteration.
func _physics_process(_delta: float) -> void:
	var is_damaging = _has_valid_enemies()

	if is_damaging and not was_damaging:
		damage_started.emit()
	elif not is_damaging and was_damaging:
		damage_stopped.emit()

	was_damaging = is_damaging

	# Deal damage per second to all overlapping enemies (damage * delta each frame).
	for enemy in overlapping_enemies:
		if enemy != null and enemy.is_inside_tree():
			enemy._take_damage(damage * _delta)

	# Emit damage_tick for each enemy at regular intervals for particle/effect spawning.
	if is_damaging:
		particle_timer += _delta
		if particle_timer >= particle_tick_interval:
			particle_timer = 0.0
			for enemy in overlapping_enemies:
				if enemy != null and enemy.is_inside_tree():
					var contact_pos = _get_contact_position(enemy)
					damage_tick.emit(enemy, contact_pos)

func _get_contact_position(enemy: EnemyHitPoints) -> Vector3:
	## Returns a point on the enemy's collision surface closest to the lance.
	## Falls back to enemy center if the shape type isn't handled.
	var lance_pos: Vector3 = global_position
	var enemy_pos: Vector3 = enemy.global_position

	if enemy.shape is SphereShape3D:
		var radius: float = enemy.shape.radius
		var direction: Vector3 = (lance_pos - enemy_pos).normalized()
		if direction == Vector3.ZERO:
			direction = Vector3(1, 0, 0)
		return enemy_pos + direction * radius

	if enemy.shape is CapsuleShape3D:
		var radius: float = enemy.shape.radius
		var direction: Vector3 = (lance_pos - enemy_pos).normalized()
		if direction == Vector3.ZERO:
			direction = Vector3(1, 0, 0)
		return enemy_pos + direction * radius

	# Fallback to enemy center for unsupported shape types
	return enemy_pos

func _has_valid_enemies() -> bool:
	for enemy in overlapping_enemies:
		if enemy != null and enemy.is_inside_tree():
			return true
	return false

func _on_body_entered(body: Node3D) -> void:
	for child in body.get_children():
		if child is EnemyHitPoints:
			if overlapping_enemies.has(child) == false:
				overlapping_enemies.append(child)

func _on_body_exited(body: Node3D) -> void:
	for child in body.get_children():
		if child is EnemyHitPoints:
			overlapping_enemies.erase(child)

func _destroy() -> void:
	destroyed.emit()
	queue_free()
