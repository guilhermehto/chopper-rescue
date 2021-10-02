extends Camera

var initial_rotation: Basis

var initial_global_position: Vector3
var parent_transform: Transform

func _ready() -> void:
	set_as_toplevel(true)
	initial_rotation = global_transform.basis
	initial_global_position = global_transform.origin
	var parent_transform = get_parent().global_transform
	
	

func _process(delta: float) -> void:
	parent_transform = get_parent().global_transform
	global_transform.origin = parent_transform.origin + initial_global_position.rotated(Vector3.UP, get_parent().rotation.y)
	look_at(parent_transform.origin, Vector3.UP)
