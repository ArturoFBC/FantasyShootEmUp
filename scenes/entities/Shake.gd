class_name Shake
extends Node

## Maximum distance the parent can be offset during shake.
@export var shake_amount: float = 0.1
## How fast the shake oscillates (cycles per second).
@export var shake_speed: float = 25.0
## How quickly the shake ramps up or fades out.
@export var shake_decay: float = 8.0

var is_shaking: bool = false
var shake_intensity: float = 0.0
var time: float = 0.0
var target: Node3D
var original_position: Vector3

func _ready() -> void:
	target = get_parent()
	if target is Node3D:
		original_position = target.position

	# Connect to the parent's damage signals if they exist.
	var parent: Node = get_parent()
	if parent.has_signal("damage_started"):
		parent.damage_started.connect(start_shake)
	if parent.has_signal("damage_stopped"):
		parent.damage_stopped.connect(stop_shake)

func _process(delta: float) -> void:
	time += delta

	if is_shaking:
		shake_intensity = lerp(shake_intensity, 1.0, shake_decay * delta)
	else:
		shake_intensity = lerp(shake_intensity, 0.0, shake_decay * delta)

	if target is Node3D:
		if shake_intensity > 0.001:
			var offset = Vector3(
				sin(time * shake_speed) * shake_amount * shake_intensity,
				cos(time * shake_speed * 0.7) * shake_amount * shake_intensity,
				sin(time * shake_speed * 0.5) * shake_amount * shake_intensity
			)
			target.position = original_position + offset
		elif shake_intensity <= 0.001 and not is_shaking:
			target.position = original_position

func start_shake() -> void:
	is_shaking = true

func stop_shake() -> void:
	is_shaking = false
