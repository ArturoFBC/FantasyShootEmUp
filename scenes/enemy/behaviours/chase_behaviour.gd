class_name ChaseBehaviour
extends BaseBehaviour

@export var rotating_speed : float = 1.0
@export var chase_speed: float = 2.0
@export var target_detector: PlayerProximityCondition

var target: Node3D


func _start_internal() -> void :
	if target == null:
		target = target_detector.get_player()
	
	
func _process(delta: float) -> void:
		if target == null:
			return 
			
		var target_position = target.global_position
		var target_transform = root_node.global_transform.looking_at(target_position, Vector3.UP, true)
		
		var allowed_rotation = rotating_speed * delta
			
		var target_basis: Basis = target_transform.basis
			
		var current_rotation: Vector3 = root_node.rotation
		var target_rotation: Vector3 = target_basis.get_euler()
			
		var target_y = lerp_angle(current_rotation.y, target_rotation.y, 1.0)
		var clamped_y = clamp(target_y, current_rotation.y - allowed_rotation, current_rotation.y + allowed_rotation)
			
		root_node.rotation.y = clamped_y
		root_node.position += root_node.basis.z * chase_speed * delta
