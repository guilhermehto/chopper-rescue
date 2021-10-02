extends Control
class_name GUI

onready var tween: Tween = $Tween
onready var notification: Label = $List/Notification

export var default_notification_time: float = 5

func notify(message: String, notification_time: float = default_notification_time) -> void:
	notification.modulate.a
	notification.text = message
	tween.interpolate_property(notification, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), notification_time / 2, Tween.TRANS_ELASTIC, Tween.EASE_IN)
	tween.interpolate_property(notification, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), notification_time / 2, Tween.TRANS_ELASTIC, Tween.EASE_IN, notification_time / 2)
	tween.start()
	
