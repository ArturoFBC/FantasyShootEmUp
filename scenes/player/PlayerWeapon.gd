extends Weapon

enum WeaponType
{
	main,
	secondary
}

@export var shot_point_containers: Array[Node]
@export var type: WeaponType = WeaponType.main

var spawn_points_by_level: Array[Array] = []
@export var level: int = 0


func _process(_delta: float) -> void:
	_shot_logic()
	

func _ready() -> void:
	_connect_to_powerup_catcher()
	_create_projectile_spawn_points_array()


func _connect_to_powerup_catcher() -> void:
	var connected_to_powerup_catcher: bool = false
	for sibling in get_parent().get_children():
		if sibling is PowerUpCatcher :
			if type == WeaponType.main :
				sibling.power_up_main_grabbed.connect(_level_up)
			else :
				sibling.power_up_secondary_grabbed.connect(_level_up)
			connected_to_powerup_catcher = true
			break
	
	if connected_to_powerup_catcher == false:
		push_error("Player weapon could not connect to power up catcher on player")


func _create_projectile_spawn_points_array() -> void:
	for container in shot_point_containers:
		var points: Array[PlayerProjectileSpawnPoint] = []
		for child in container.get_children():
			if child is PlayerProjectileSpawnPoint:
				points.append(child)
		spawn_points_by_level.append(points)


func _shot_logic() -> void:
	# if the player shot is not on cooldown and the fire button is pressed, shot
	if Input.is_action_pressed("fire") and not shot_on_cd:
		_shot()
		# shot cooldown
		_wait_cooldown()


func _shot() -> void:
	var points: Array = spawn_points_by_level[level]
	for spawnPoint: PlayerProjectileSpawnPoint in points:
		if spawnPoint.alternative > spawnPoint.alternative_offset:
			spawnPoint.alternative_offset =+ 1
		else:
			spawnPoint.alternative_offset = 0
			var projectile := projectile_scene.instantiate()
			get_tree().current_scene.add_child(projectile)
			projectile.init(spawnPoint, damage, spawnPoint.left_side)
			

func _level_up() -> void:
	level = min(level + 1, spawn_points_by_level.size() - 1)
