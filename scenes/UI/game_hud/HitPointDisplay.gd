class_name HitPointDisplay
extends TextureProgressBar

var current_hp: float
var max_hp: float


func _ready():
	SignalBus.connect("player_HP_updated", Callable(self, "_on_player_HP_updated"))
	SignalBus.connect("player_maxHP_updated", Callable(self, "_on_player_maxHP_updated"))


func _on_player_HP_updated(new_hp: float, previous_hp: float):
	current_hp = new_hp
	value = new_hp / max_hp
	
	
func _on_player_maxHP_updated(new_hp: float, previous_hp: float):
	max_hp = new_hp
	
