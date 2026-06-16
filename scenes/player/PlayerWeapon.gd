extends Weapon

@export var shot_point_containers: Array[Node]

var spawn_points_by_level: Array[Array] = []
var level: int = 0


func _process(_delta: float) -> void:
	_shot_logic()
	

func _ready() -> void:
	for container in shot_point_containers:
		var points: Array[PlayerProjectileSpawnPoint] = []
		for child in container.get_children():
			if child is PlayerProjectileSpawnPoint:
				points.append(child)
				print(child.position);
		spawn_points_by_level.append(points)


func _shot_logic() -> void:
	# if the player shot is not on cooldown and the fire button is pressed, shot
	if Input.is_action_pressed("fire") and not shot_on_cd:
		_shot()
		# shot cooldown
		shot_on_cd = true
		await get_tree().create_timer(fire_rate).timeout
		shot_on_cd = false


func _shot() -> void:
	var points: Array = spawn_points_by_level[level]
	for spawnPoint: PlayerProjectileSpawnPoint in points:
		if spawnPoint.alternative > spawnPoint.alternative_offset:
			spawnPoint.alternative_offset =+ 1
		else:
			spawnPoint.alternative_offset = 0
			var projectile := projectile_scene.instantiate()
			get_tree().current_scene.add_child(projectile)
			projectile.init(spawnPoint, damage)
