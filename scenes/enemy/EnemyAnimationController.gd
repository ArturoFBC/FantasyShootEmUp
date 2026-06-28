class_name EnemyAnimationController
extends AnimationTree


func _on_weapon_weapon_shot(attacking: bool) -> void:
	set("parameters/conditions/attack", attacking)
	set("parameters/conditions/fly", attacking == false)
