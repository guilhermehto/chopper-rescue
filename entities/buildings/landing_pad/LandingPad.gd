extends Spatial

onready var timer: Timer = $Timer

export var refuel_speed := 5.0
export var time_to_unboard := 1.0

var helicopter: Helicopter

func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	if helicopter == null:
		return
	
	helicopter.fuel_time += refuel_speed * delta

func _on_Area_body_entered(body: Node) -> void:
	if body is Helicopter:
		set_process(true)
		helicopter = body
		timer.wait_time = time_to_unboard
		timer.start()

func _on_Area_body_exited(body: Node) -> void:
	helicopter = null
	set_process(false)
	timer.stop()


func _on_Timer_timeout() -> void:
	if helicopter != null:
		helicopter.unboard_rescuee()
		timer.start()
