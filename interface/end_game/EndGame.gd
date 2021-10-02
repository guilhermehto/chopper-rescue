extends Control

export var game_scene: PackedScene

onready var title: Label = $List/Title
onready var time_played: Label = $List/TimePlayed
onready var rescued: Label = $List/Rescued

var end_game_titles := [
	"Oh no! You lose!",
	"Guess who had their flying license revoked? Not me!",
	"This ain't fast & furious",
	"Not again...",
	"Crap! Third pilot we lose this week."
]

func initialize(played_time: float, rescued_count: int) -> void:
	rescued.text = "You managed to rescue %s people!" % rescued_count
	var seconds_played = int(fmod(played_time, 60.0))
	var display_seconds_played = str(seconds_played) if seconds_played > 10 else "0%s" % seconds_played
	
	var minutes_played = int(seconds_played / 60)
	var display_minutes_played = str(minutes_played) if seconds_played > 10 else "0%s" % minutes_played
	
	time_played.text = "Total playtime: %s:%s" % [display_minutes_played, display_seconds_played]

func _ready() -> void:
	randomize()
	title.text = end_game_titles[randi() % end_game_titles.size()]

func _on_TryAgain_pressed() -> void:
	get_tree().reload_current_scene()

func _on_Quit_pressed() -> void:
	get_tree().quit()
