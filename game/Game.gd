extends Node

export var end_game_menu_scene: PackedScene

onready var level: Spatial = $Level

var rescued: int = 0
var game_time: float = 0

func _process(delta: float) -> void:
	game_time += delta

func _on_Level_game_ended() -> void:
	set_process(false)
	var end_game_menu = end_game_menu_scene.instance()
	add_child(end_game_menu)
	end_game_menu.initialize(game_time, rescued)
	level.queue_free()
