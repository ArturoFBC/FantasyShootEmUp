class_name ProjectileBlocking
extends Node


@export var projectile_blocks: int = 3
var projectile_blocks_remaining: int


func _ready() -> void:
	projectile_blocks_remaining = projectile_blocks


func _on_shield_projectile_area_entered(area: Area3D) -> void:
	if area is Projectile:
		area._destroy()
		projectile_blocks_remaining -= 1
		if projectile_blocks_remaining <= 0:
			get_parent()._destroy()
