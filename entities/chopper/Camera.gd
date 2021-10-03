extends Camera

var initial_global_position: Vector3
var parent_transform: Transform

var target: Vector3

var default_following_speed: float = 20
var catch_up_following_speed: float = 150
var desired_distance: float

func _ready() -> void:
	set_as_toplevel(true)
	initial_global_position = global_transform.origin
	desired_distance = target.distance_to(global_transform.origin)
	desired_distance *= 1.25

func _process(delta: float) -> void:
	parent_transform = get_parent().global_transform
	target = parent_transform.origin + initial_global_position.rotated(Vector3.UP, get_parent().rotation.y)
	global_transform.origin.y = target.y
	var direction = (target - global_transform.origin).normalized()
	var speed = default_following_speed if target.distance_to(global_transform.origin) < desired_distance else catch_up_following_speed
	global_transform.origin += direction * speed * delta
	look_at(parent_transform.origin, Vector3.UP)
