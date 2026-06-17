class_name Projectile
extends Area3D

enum TargetType
{
	Player,
	Enemy
}

@export var speed: float = 1  ## How fast the shot moves
@export var damage: float = 1  ## How much damage the shot does

@export var target_type: TargetType  ## How much damage the shot does

var direction: Vector3 = Vector3.LEFT  ## Direction of the shot

@onready var collision_shape: CollisionShape3D = $CollisionShape3D  ## Collision shape
@onready var mesh: MeshInstance3D = $MeshInstance3D  ## Shot mesh
@onready var shot_hit: AudioStreamPlayer3D = $ShotHit  ## Shot hit sound


## Initialize the shot when from a spawn point and an energy type
func init(from: Marker3D, new_damage: float) -> void:
	global_position = from.global_position
	global_rotation = from.global_rotation
	damage = new_damage


## Called every physics iteration, delta is the elapsed time since the previous call, this is FPS independent
func _physics_process(_delta: float) -> void:
	global_position += basis.z * speed


## Called when the shot goes off screen
func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	# delete the shot
	queue_free()
	

## Called when the shot enters in a body
func _on_body_entered(body:Node3D) -> void:
	print("hit")
	for child in body.get_children():
		if (target_type == TargetType.Player):
			if (child is PlayerHitPoints):
				child._take_damage(damage)
				destroy()
		else:
			if (child is EnemyHitPoints):
				child._take_damage(damage)
				destroy()


func destroy() -> void:
	# disable the collision shape, in the next physics iteration, so no more collisions
	collision_shape.set_deferred("disabled", true)

	# stop the shot for moving, hide the sprite and play the hit sound
	direction = Vector3.ZERO
	mesh.visible = false
	shot_hit.play()

	queue_free()
