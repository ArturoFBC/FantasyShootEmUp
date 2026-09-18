class_name PlayerData
extends Node


var player_class: PlayerClass

var main_weapon_index: int
var main_weapon_level: int

var off_weapon_index: int
var off_weapon_level: int


func _set_player_class(new_class : PlayerClass) -> void:
	player_class = new_class


func _set_player_main_weapon(new_weapon : int) -> void:
	main_weapon_index = new_weapon


func _set_player_secondary_weapon(new_weapon : int) -> void:
	off_weapon_index = new_weapon
