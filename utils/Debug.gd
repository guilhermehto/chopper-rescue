extends Node

signal started_debugging
signal stopped_debugging

var is_debugging = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_debug"):
		is_debugging = !is_debugging
		print("[TOGGLED DEBUG] %s" % ("ON" if is_debugging else "OFF"))
		emit_signal("started_debugging") if is_debugging else emit_signal("stopped_debugging")
