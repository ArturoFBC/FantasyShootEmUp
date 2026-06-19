class_name ContactDamage
extends Area3D

@export var damage: float = 1  ## How much damage the shot does
@export var destroy_on_contact: bool = true  ## How much damage the shot does

@onready var my_hit_points: EnemyHitPoints = %EnemyHitPoints
@onready var my_collision_shape: CollisionShape3D = %ContactCollision


func _ready():
	my_collision_shape.shape = my_hit_points.shape


func _on_body_entered(body: Node3D) -> void:
	for child in body.get_children():
		if (child is PlayerHitPoints):
			child._take_damage(damage)
			if (destroy_on_contact):
				my_hit_points._die()
