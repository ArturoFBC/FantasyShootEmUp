class_name WeaponShuriken
extends PlayerWeapon

@export var detect_radious: float = 6.0
@export var collision: CollisionShape3D

@onready var root_node: Node3D = get_parent()

var targets: Array[Node3D]


func _ready() -> void:
	collision.scale = Vector3.ONE * detect_radious
	_connect_to_powerup_catcher()
	_create_projectile_spawn_points_array()


func _shot_condition() -> bool:
	return Input.get_vector("aim_left","aim_right","aim_up","aim_down") != Vector2.ZERO && targets.size() > 0
	
	
func _shot() -> void:
	_clean_targets()
	
	targets.sort_custom(_closest)

	for spawn_point_index in range(spawn_points_by_level[level].size()):
		spawn_points_by_level[level][spawn_point_index].look_at(targets[spawn_point_index].global_position, Vector3.UP, true)

	_shot_internal()


func _closest(a, b) -> bool:
	return (a.global_position - root_node.global_position).length_squared() < (b.global_position - root_node.global_position).length_squared()


func _clean_targets() -> void:
	for target_index in range(targets.size() -1, -1, -1):
		if targets[target_index] == null:
			targets.remove_at(target_index)


func _on_area_3d_body_entered(body: Node3D) -> void:
	for child in body.get_children():
		if child is EnemyHitPoints:
			if targets.has(body) == false:
				targets.append(body)
				break


func _on_area_3d_body_exited(body: Node3D) -> void:
	if targets.has(body):
		targets.erase(body)
