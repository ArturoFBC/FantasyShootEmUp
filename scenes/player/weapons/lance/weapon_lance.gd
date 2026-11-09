class_name WeaponLance
extends PlayerWeapon

## Overrides the base shot logic so the spawned lance becomes a child of
## the spawn point. Since the spawn point is attached to the weapon (and
## the weapon to the player), the lance follows the player automatically
## without needing to lerp its position every frame.
func _shot_internal() -> void:
	if level >= spawn_points_by_level.size():
		push_error("WeaponLance '%s': level %d exceeds spawn_points_by_level array size %d." % [name, level, spawn_points_by_level.size()])
		return
	for spawnPoint: PlayerProjectileSpawnPoint in spawn_points_by_level[level]:
		if spawnPoint.alternative > spawnPoint.alternative_offset:
			spawnPoint.alternative_offset += 1
		else:
			spawnPoint.alternative_offset = 0
			var proj_level := spawnPoint.projectile_level
			if proj_level >= projectiles.size():
				push_error("WeaponLance '%s': projectile_level %d exceeds projectiles array size %d." % [name, proj_level, projectiles.size()])
				return
			if proj_level >= damages.size():
				push_error("WeaponLance '%s': projectile_level %d exceeds damages array size %d." % [name, proj_level, damages.size()])
				return
			var lance = projectiles[proj_level].instantiate()
			# Parent to the spawn point so it inherits the player's transform.
			spawnPoint.add_child(lance)
			lance.init(damages[proj_level])
