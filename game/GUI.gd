extends Control
class_name GUI

onready var tween: Tween = $Tween
onready var notification: Label = $List/Notification
onready var rescuees: Label = $List/Row/Rescuees
onready var time_left: Label = $List/Row/TimeLeft

export var default_notification_time: float = 5

var current_rescuee_group: RescueeGroup

func notify(message: String, notification_time: float = default_notification_time) -> void:
	notification.modulate.a
	notification.text = message
	tween.interpolate_property(notification, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), notification_time / 2, Tween.TRANS_ELASTIC, Tween.EASE_IN)
	tween.interpolate_property(notification, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), notification_time / 2, Tween.TRANS_ELASTIC, Tween.EASE_IN, notification_time / 2)
	tween.start()

func display_new_rescuee_group(group: RescueeGroup) -> void:
	current_rescuee_group = group
	time_left.text = str(int(current_rescuee_group.time_to_die))
	group.connect("groupe_rescued", self, "_on_group_rescued")
	group.connect("rescuee_group_died", self, "_on_group_died")

func _process(delta: float) -> void:
	current_rescuee_group.time_to_die -= delta
	time_left.text = "%s'" % int(current_rescuee_group.time_to_die)

func _on_PhysicsChopper_passenger_boarded(carrying, capacity) -> void:
	rescuees.text = "%s/%s" % [carrying, capacity]

func _on_PhysicsChopper_rescuee_unboarded(carrying, capacity) -> void:
	rescuees.text = "%s/%s" % [carrying, capacity]

func _on_group_rescued() -> void:
	notify("Rescuee group rescued!")

func _on_group_died() -> void:
	notify("Rescuee group died!")
