class_name Projectile
extends Area3D

enum TargetType
{
	Player,
	Enemy
}

signal destroyed()
signal set_side(left: bool)

@export var speed: float = 10  ## How fast the shot moves
@export var damage: float = 1  ## How much damage the shot does

@export var target_type: TargetType  ## How much damage the shot does

var direction: Vector3 = Vector3.LEFT  ## Direction of the shot

@onready var collision_shape: CollisionShape3D = $CollisionShape3D  ## Collision shape


## Initialize the shot when from a spawn point and an energy type
func init(from: Marker3D, new_damage: float, left_side: bool) -> void:
	global_position = from.global_position
	global_rotation = from.global_rotation
	set_side.emit(left_side)
	damage = new_damage
	
	if body_entered.is_connected(_on_body_entered) == false:
		body_entered.connect(_on_body_entered)


## Called every physics iteration, delta is the elapsed time since the previous call, this is FPS independent
func _physics_process(_delta: float) -> void:
	global_position += basis.z * speed * _delta


## Called when the shot goes off screen
func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	# delete the shot
	queue_free()
	

## Called when the shot enters in a body
func _on_body_entered(body:Node3D) -> void:
	for child in body.get_children():
		if (target_type == TargetType.Player):
			if (child is PlayerHitPoints):
				child._take_damage(damage)
		else:
			if (child is EnemyHitPoints):
				child._take_damage(damage)
				
	destroy()


func destroy() -> void:
	# disable the collision shape, in the next physics iteration, so no more collisions
	collision_shape.set_deferred("disabled", true)

	# stop the shot for moving, hide the sprite and play the hit sound
	direction = Vector3.ZERO
	
	destroyed.emit()
	
	queue_free()
