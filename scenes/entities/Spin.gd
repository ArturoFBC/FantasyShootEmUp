extends Node

@export var axis: Vector3 = Vector3(0,1,0)
@export var speed: float = 30
@export var deceleration: float = 0
@export var target: Node3D

func _ready() -> void:
	if target == null:
		target = get_parent()
		
		
func _on_area_3d_set_side(left: bool) -> void:
	if left :
		speed = -speed
		deceleration = -deceleration
		

func _physics_process(delta: float) -> void:
	## rotate speed radians, decrease speed by deceleration
	target.rotate_object_local(axis, speed * delta)
	speed += deceleration * delta
	if deceleration != 0 && ((deceleration > 0) == (speed > 0)) :
		process_mode = Node.PROCESS_MODE_DISABLED
