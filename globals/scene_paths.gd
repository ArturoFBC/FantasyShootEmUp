class_name ScenePaths
extends RefCounted

enum Id {
	TITLE,
	PLAYER_SELECT,
	IN_GAME,
	MAP,
	UPGRADE,
}

const TITLE := "res://scenes/UI/screens/title/title.tscn"
const PLAYER_SELECT := "res://scenes/player_select.tscn"
const IN_GAME := "res://scenes/levels/in_game.tscn"
const MAP := "res://scenes/UI/screens/map/map.tscn"
const UPGRADE := "res://scenes/UI/screens/upgrade/upgrade.tscn"

const PATHS := {
	Id.TITLE: TITLE,
	Id.PLAYER_SELECT: PLAYER_SELECT,
	Id.IN_GAME: IN_GAME,
	Id.MAP: MAP,
	Id.UPGRADE: UPGRADE,
}


static func path(id: Id) -> String:
	return PATHS[id]
