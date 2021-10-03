extends Control

export var game_scene: PackedScene
export var options_scene: PackedScene

func _on_Start_pressed() -> void:
	get_tree().change_scene_to(game_scene)

func _on_Quit_pressed() -> void:
	get_tree().quit()
