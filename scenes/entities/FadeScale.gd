class_name FadeScale
extends Node

## Time to scale in from zero.
@export var fade_in: float = 0.2
## How long to hold at full scale before fading out.
@export var hold_duration: float = 0.0
## Time to scale out from full to zero.
@export var fade_out: float = 0.2
## If true, queue_free() the parent node when the fade completes.
@export var queue_free_on_complete: bool = true
## Optional curve mapping normalized time [0,1] to scale factor.
## Used directly for fade_in; reversed (1 - t) for fade_out.
@export var scale_curve: Curve

signal fade_complete

var time_alive: float = 0.0
var target: Node3D
var original_scale: Vector3

func _ready() -> void:
	target = get_parent()
	if target is Node3D:
		original_scale = target.scale
		target.scale = Vector3(0.001, 0.001, 0.001)

func _curve_factor(t: float) -> float:
	t = clamp(t, 0.0, 1.0)
	if scale_curve != null:
		return scale_curve.sample(t)
	# Fallback smoothstep when no curve is assigned.
	return t * t * (3.0 - 2.0 * t)

func _process(delta: float) -> void:
	time_alive += delta
	var total_duration = fade_in + hold_duration + fade_out

	if time_alive >= total_duration:
		if queue_free_on_complete and target != null:
			target.queue_free()
		fade_complete.emit()
		return

	var factor: float
	if fade_in > 0 and time_alive < fade_in:
		var progress = time_alive / fade_in
		factor = _curve_factor(progress)
	elif hold_duration > 0 and time_alive < fade_in + hold_duration:
		factor = 1.0
	elif fade_out > 0:
		var progress = (time_alive - fade_in - hold_duration) / fade_out
		factor = _curve_factor(1.0 - progress)
	else:
		factor = 1.0

	if target is Node3D:
		factor = max(factor, 0.001)
		target.scale = original_scale * factor
