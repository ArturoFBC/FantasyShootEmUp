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
	return Input.get_vector("aim_left","aim_right","aim_up","aim_down") != Vector2.ZERO
	
	
func _shot() -> void:
	_clean_targets()
	
	var closest_targets = _get_closest_targets()
	print(targets.size())
	for target in closest_targets:
		var projectile := projectile_scene.instantiate()
		get_tree().current_scene.add_child(projectile)
		spawn_points_by_level[0][0].look_at(target.global_position, Vector3.UP, true)
		projectile.init(spawn_points_by_level[0][0], damage, false)


func _get_closest_targets() -> Array[Node3D]:
	var closest_targets: Array[Node3D]
	if targets.size() == 0:
		##Exit early if no targets
		return closest_targets
	
	var target_amount: int = floor(level / 2 + 1)
	
	## Get array of distances with same order as target array. Values are squared for faster calculation without affecting order
	var distances_squared: Array[float]
	for target in targets:
		var distance = (target.global_position - root_node.global_position).length_squared()
		distances_squared.append(distance)
	
	for current_target in target_amount:
		if targets.size() <= current_target:
			break
		
		var current_distance: float = distances_squared[0]
		var current_closest: Node3D = targets[0]
		for target_index in targets.size():
			if current_distance >= distances_squared[target_index]:
				if closest_targets.has(targets[target_index]) != null:
					current_closest = targets[target_index]
					current_distance = distances_squared[target_index]
		
		closest_targets.append(current_closest)
		
	return closest_targets


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
