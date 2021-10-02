extends Spatial

export var refuel_speed = 5.0

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

func _on_Area_body_exited(body: Node) -> void:
	helicopter = null
	set_process(false)
