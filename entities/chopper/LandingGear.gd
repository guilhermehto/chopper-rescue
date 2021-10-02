extends Area

signal landed
signal took_off

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")


func _on_body_entered(body: Node) -> void:
	emit_signal("landed")

func _on_body_exited(body: Node) -> void:
	emit_signal("took_off")
