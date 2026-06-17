class_name HitPoints
extends CollisionShape3D

signal hp_changed(previous_hp: float, new_hp: float)

@export var max_hp: float = 100

@onready var current_hp: float = max_hp


	
