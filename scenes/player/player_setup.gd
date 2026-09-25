class_name PlayerSetUp
extends Node

@export var base_player_node: Node3D
@export var flicker_effect: FlickerOnDamage


func _ready() -> void:
	var player_class = GlobalData.current_character_class
	var player_model: Node3D = player_class.graphic.instantiate()
	base_player_node.add_child.call_deferred(player_model)
	player_model.scale = (Vector3(1.5,1.5,1.5))
	flicker_effect.my_mesh = player_model
	
	var main_weapon = player_class.main_weapons[0].instantiate()
	main_weapon.rotate(Vector3(0,1,0), PI)
	base_player_node.add_child.call_deferred(main_weapon)
	var off_weapon: Node3D = player_class.off_weapons[0].instantiate()
	print(off_weapon.rotation_degrees)
	off_weapon.rotate(Vector3(0,1,0), PI)
	base_player_node.add_child.call_deferred(off_weapon)
	print(off_weapon.rotation_degrees)
