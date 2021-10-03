extends Spatial

signal rescuee_group_died
signal groupe_rescued

onready var rescuees: Spatial = $Rescuees
onready var timer: Timer = $Timer

export var time_to_die: float = 45

var helicopter: Helicopter 

func _ready() -> void:
	randomize()
	set_process(false)
	var max_number_of_rescuees = rescuees.get_child_count()
	var number_of_rescuees = int(rand_range(3, max_number_of_rescuees + 1))
	for i in max_number_of_rescuees - number_of_rescuees:
		var index = randi() % max_number_of_rescuees
		rescuees.get_child(index).queue_free()
	for rescuee in rescuees.get_children():
		rescuee.connect("picked_up", self, "_on_rescuee_picked_up")
	
	time_to_die += global_transform.origin.distance_to(Vector3.ZERO) / 20
	time_to_die += number_of_rescuees / 4 * 15
	timer.wait_time = time_to_die
	timer.connect("timeout", self, "_on_timer_timeout")
	timer.start()
	
func _on_rescuee_picked_up() -> void:
	if rescuees.get_child_count() - 1 == 0:
		emit_signal("groupe_rescued")
		queue_free()

func _on_heli_landing_status_changed(is_landed: bool) -> void:
	match is_landed:
		true:
			_refugees_start_following()
		false:
			_refugees_stop_following()

func _on_heli_passenger_boarded(carrying: int, capacity: int) -> void:
	if carrying == capacity:
		_refugees_stop_following()

func _on_Area_body_entered(body: Node) -> void:
	if body is Helicopter:
		helicopter = body
		helicopter.connect("landing_status_changed", self, "_on_heli_landing_status_changed")
		helicopter.connect("passenger_boarded", self, "_on_heli_passenger_boarded")
		if helicopter.is_landed and helicopter.rescuees_being_carried < helicopter.rescuee_capacity:
			_refugees_start_following()

func _on_Area_body_exited(body: Node) -> void:
	if body is Helicopter:
		helicopter.disconnect("landing_status_changed", self, "_on_heli_landing_status_changed")
		helicopter.disconnect("passenger_boarded", self, "_on_heli_passenger_boarded")
		_refugees_stop_following()
		helicopter = null

func _refugees_start_following() -> void:
	for rescuee in rescuees.get_children():
		rescuee.follow_target(helicopter.global_transform)

func _refugees_stop_following() -> void:
	for rescuee in rescuees.get_children():
		rescuee.stop_following_target()

func _on_timer_timeout() -> void:
	emit_signal("rescuee_group_died")
	queue_free()
