extends Button

export var scene: PackedScene

func _ready() -> void:
	connect("pressed", self, "_on_pressed")

func _on_pressed() -> void:
	get_tree().change_scene_to(scene)
