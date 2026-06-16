extends CharacterBody3D

@export var speed: float = 8  ## How fast the player moves
@export var stage_limit: Vector2 = Vector2(10, 20)
@export var bounds: Vector3 = Vector3(1,0,1)


## Called every physics iteration, delta is the elapsed time since the previous call, this is FPS independent
func _physics_process(_delta: float) -> void:
	var x_axis: float = Input.get_axis("left", "right")
	var z_axis: float = Input.get_axis("up", "down")
	var direction: Vector3 = Vector3(x_axis, 0, z_axis)

	# calculate the velocity based on the direction and speed
	velocity = direction * speed

	# move the player
	if direction != Vector3.ZERO:
		move_and_slide()

	# clamp the player, we do this even without moving because the user can resize the window
	#var half_limits: Vector3 = Vector3(stage_limit.x, 0, stage_limit.y) / 2
	#position = position.clamp(-half_limits + bounds /2, half_limits - bounds /2)
