class_name EnemyWeapon
extends Weapon

@onready var shot_point: Marker3D = $ShotPoint  ## Shot spawn point



func _process(_delta: float) -> void:
	_shot_logic()


## Decice if the player will shoot
func _shot_logic() -> void:
	# if the player shot is not on cooldown and the fire button is pressed, shot
	if not shot_on_cd:
		_shot()
		# shot cooldown
		shot_on_cd = true
		await get_tree().create_timer(fire_rate).timeout
		shot_on_cd = false


## Make the shoot
func _shot() -> void:
	# spawn the projectiles from the spawn points
	var shot_instance: Projectile = projectile_scene.instantiate()
	get_parent().add_child(shot_instance)
	shot_instance.init(shot_point, damage)
	
	weapon_shot.emit()
