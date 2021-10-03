extends Spatial

onready var pointer = $Pointer

var max_fuel: float = 60
var fuel: float = 60

var rotation_range = deg2rad(160) * 2

func _process(delta: float) -> void:
	pointer.rotation.z = -(fuel / max_fuel * rotation_range - rotation_range / 2)
