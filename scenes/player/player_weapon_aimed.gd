class_name PlayerWeaponAimed
extends PlayerWeapon

func _shot_condition() -> bool:
	return Input.get_vector("aim_left","aim_right","aim_up","aim_down") != Vector2.ZERO
	
	
func _shot() -> void:
	var input = Input.get_vector("aim_left","aim_right","aim_up","aim_down")
	if input.x == 0 || input.y == 0:
		#When playing with keyboard it is difficult to shoot diagonally the first shot because it requires 2 keys and one is going to be pressed first.
		#Thus this grace period.
		await get_tree().create_timer(0.01).timeout
		if input.x == 0:
			input.x = Input.get_axis("aim_left","aim_right")
		else:
			input.y = Input.get_axis("aim_up","aim_down")

	var direction = input.angle_to(Vector2.DOWN)
	shot_point_containers[level].rotation = Vector3(0, direction, 0)
	_shot_internal()
