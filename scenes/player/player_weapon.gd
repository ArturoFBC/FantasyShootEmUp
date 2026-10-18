class_name PlayerWeapon
extends Node

enum WeaponType
{
	main,
	secondary
}


signal weapon_shot(attacking: bool) 


@export var level: int = 0

@export var shot_point_containers: Array[Node] # One per level
@export var type: WeaponType = WeaponType.main
var spawn_points_by_level: Array[Array] = []

@export var fire_rate: Array[float] # One per level
@export var projectiles: Array[PackedScene] # Set on the PlayerProjectileSpawnPoint inside spawn point containers
@export var damages: Array[float]

var shot_on_cd: bool = false


func _process(_delta: float) -> void:
	_shot_logic()
	

func _ready() -> void:
	_connect_to_signal_bus()
	_create_projectile_spawn_points_array()


func _exit_tree() -> void:
	_disconnect_from_signal_bus()


func _connect_to_signal_bus() -> void:
	if type == WeaponType.main:
		SignalBus.connect("power_up_main_grabbed", _level_up)
	else:
		SignalBus.connect("power_up_secondary_grabbed", _level_up)


func _disconnect_from_signal_bus() -> void:
	if type == WeaponType.main:
		if SignalBus.is_connected("power_up_main_grabbed", _level_up):
			SignalBus.disconnect("power_up_main_grabbed", _level_up)
	else:
		if SignalBus.is_connected("power_up_secondary_grabbed", _level_up):
			SignalBus.disconnect("power_up_secondary_grabbed", _level_up)


func _create_projectile_spawn_points_array() -> void:
	for container in shot_point_containers:
		var points: Array[PlayerProjectileSpawnPoint] = []
		for child in container.get_children():
			if child is PlayerProjectileSpawnPoint:
				points.append(child)
		spawn_points_by_level.append(points)


func _shot_logic() -> void:
	# if the player shot is not on cooldown and the fire button is pressed, shot
	if _shot_condition() and not shot_on_cd:
		_shot()
		# shot cooldown
		_wait_cooldown()


func _shot_condition() -> bool:
	return Input.is_action_pressed("fire")


func _shot() -> void:
	_shot_internal()


func _shot_internal() -> void:
	if level >= spawn_points_by_level.size():
		push_error("PlayerWeapon '%s': level %d exceeds spawn_points_by_level array size %d. Check the weapon's shot_point_containers export." % [name, level, spawn_points_by_level.size()])
		return
	for spawnPoint: PlayerProjectileSpawnPoint in spawn_points_by_level[level]:
		if spawnPoint.alternative > spawnPoint.alternative_offset:
			spawnPoint.alternative_offset += 1
		else:
			spawnPoint.alternative_offset = 0
			var proj_level := spawnPoint.projectile_level
			if proj_level >= projectiles.size():
				push_error("PlayerWeapon '%s': projectile_level %d exceeds projectiles array size %d. Check the weapon's projectiles export and the spawn point's projectile_level." % [name, proj_level, projectiles.size()])
				return
			if proj_level >= damages.size():
				push_error("PlayerWeapon '%s': projectile_level %d exceeds damages array size %d. Check the weapon's damages export and the spawn point's projectile_level." % [name, proj_level, damages.size()])
				return
			var projectile := projectiles[proj_level].instantiate()
			get_tree().current_scene.add_child(projectile)
			projectile.init(spawnPoint, damages[proj_level], spawnPoint.left_side)


func _wait_cooldown():
	if level >= fire_rate.size():
		push_error("PlayerWeapon '%s': level %d exceeds fire_rate array size %d. Check the weapon's fire_rate export." % [name, level, fire_rate.size()])
		return
	shot_on_cd = true
	weapon_shot.emit(shot_on_cd)
	await get_tree().create_timer(fire_rate[level]).timeout
	if not is_inside_tree():
		return
	shot_on_cd = false
	weapon_shot.emit(shot_on_cd)


func _level_up() -> void:
	level = min(level + 1, spawn_points_by_level.size() - 1)
