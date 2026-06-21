class_name ChaserBehaviour
extends Area3D

enum ChaserState
{
	search,
	chase
}

@export var detect_radious: float = 6.0
@export var rotating_speed : float = 6.0
@export var advance_speed: float = 6.0
@export var chase_speed: float = 6.0

var target: Node3D
var state: ChaserState = ChaserState.search

@onready var root_node = get_parent()


func _ready() -> void:
	## Set detection radious
	var collision: Node3D = get_child(0)
	collision.scale = Vector3.ONE * detect_radious


func _process(delta: float) -> void:
	if state == ChaserState.search:
		root_node.position += basis.z * advance_speed * delta
	else: if state == ChaserState.chase:
		var target_vector = target.global_position
		
		var target_transform = root_node.global_transform.looking_at(target_vector, Vector3.UP)
			
		var allowed_rotation = rotating_speed * delta
			
		var target_basis: Basis = target_transform.basis
			
		var current_rotation: Vector3 = root_node.rotation
		var target_rotation: Vector3 = target_basis.get_euler()
			
		var target_y = lerp_angle(current_rotation.y, target_rotation.y, 1.0)
			
		var clamped_y = clamp(target_y, current_rotation.y - allowed_rotation, current_rotation.y + allowed_rotation)
			
		root_node.rotation.y = clamped_y
			
		root_node.position += -root_node.basis.z * chase_speed * delta


func _on_body_entered(body:Node3D) -> void:
	for child in body.get_children():
		if (child is PlayerHitPoints):
			target = child
			state = ChaserState.chase
