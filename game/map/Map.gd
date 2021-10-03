extends Spatial
class_name Map

onready var rescue_points: Node = $RescuePoints

func get_rescue_points() -> Array:
	return rescue_points.get_children()
