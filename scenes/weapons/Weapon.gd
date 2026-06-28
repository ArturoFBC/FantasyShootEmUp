class_name Weapon
extends Node

signal weapon_shot(attacking: bool)  ## Signal when the weapon has been used

@export var fire_rate: float = 0.20  ## How fast the player fires
@export var projectile_scene: PackedScene ## Shot scene
@export var damage: float = 1 ## Basic damage


var shot_on_cd: bool = false ## Flags if the weapon is in cooldown


func _wait_cooldown():
	shot_on_cd = true
	weapon_shot.emit(shot_on_cd)
	await get_tree().create_timer(fire_rate).timeout
	shot_on_cd = false
	weapon_shot.emit(shot_on_cd)
