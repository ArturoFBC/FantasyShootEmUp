class_name Weapon
extends Node

signal weapon_shot()  ## Signal when the weapon has been used

@export var fire_rate: float = 0.20  ## How fast the player fires
@export var projectile_scene: PackedScene ## Shot scene
@export var damage: float = 1 ## Basic damage


var shot_on_cd: bool = false ## Flags if the weapon is in cooldown
