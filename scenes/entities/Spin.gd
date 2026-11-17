extends Node

@export var axis: Vector3 = Vector3(0,1,0)
@export var radians_second: float = 30
@export var deceleration: float = 0
@export var target: Node3D

func _ready() -> void:
	axis = axis.normalized()
	if target == null:
		target = get_parent()
		
		
func _on_area_3d_set_side(left: bool) -> void:
	if left :
		radians_second = -radians_second
		deceleration = -deceleration
		

func _physics_process(delta: float) -> void:
	## rotate speed radians, decrease speed by deceleration
	target.rotate_object_local(axis, radians_second * delta)
	radians_second += deceleration * delta
	if deceleration != 0 && ((deceleration > 0) == (radians_second > 0)) :
		process_mode = Node.PROCESS_MODE_DISABLED
