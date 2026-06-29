class_name WeaponShield
extends PlayerWeapon

func _shot_condition() -> bool:
	return Input.get_vector("aim_left","aim_right","aim_up","aim_down") != Vector2.ZERO
	
	
func _shot() -> void:
	var input = Input.get_vector("aim_left","aim_right","aim_up","aim_down")
	if input.x == 0 || input.y == 0:
		await get_tree().create_timer(0.01).timeout
		if input.x == 0:
			input.x = Input.get_axis("aim_left","aim_right")
		else:
			input.y = Input.get_axis("aim_up","aim_down")

	var projectile := projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	var direction = input.angle_to(Vector2.DOWN)
	spawn_points_by_level[0][0].rotation = Vector3(0, direction, 0)
	projectile.init(spawn_points_by_level[0][0], damage, false)
	
