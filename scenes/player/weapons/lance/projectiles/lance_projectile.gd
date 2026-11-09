class_name LanceProjectile
extends Area3D

signal destroyed()

## Damage dealt per second to every enemy currently overlapping the lance.
@export var damage: float = 1.0
## How long the lance stays alive before disappearing.
@export var lifetime: float = 2.0

var overlapping_enemies: Array[EnemyHitPoints] = []

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

## Initialize the lance when spawned as a child of a spawn point.
func init(new_damage: float) -> void:
	damage = new_damage

## Called every physics iteration.
func _physics_process(_delta: float) -> void:
	# Deal damage per second to all overlapping enemies (damage * delta each frame).
	for enemy in overlapping_enemies:
		if enemy != null and enemy.is_inside_tree():
			enemy._take_damage(damage * _delta)

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
