class_name PlayerProjectileSpawnPoint
extends Marker3D

@export var projectile_level: int = 1
@export var alternative: int = 0 ## Use every other X shot, 0 is every shot, 1 is one in two...
@export var alternative_offset: int = 0 ## Offset so alternative shots start at a different point in the cycle
@export var left_side: bool = false ## If false, it is a left side projectile
