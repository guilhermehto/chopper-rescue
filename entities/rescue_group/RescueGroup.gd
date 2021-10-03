extends Spatial

onready var rescuees: Spatial = $Rescuees

var helicopter: Helicopter 

func _ready() -> void:
	randomize()
	var max_number_of_rescuees = rescuees.get_child_count()
	var number_of_rescuees = int(rand_range(3, max_number_of_rescuees + 1))
	for i in max_number_of_rescuees - number_of_rescuees:
		var index = randi() % max_number_of_rescuees
		rescuees.get_child(index).queue_free()
		
	set_process(false)

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
