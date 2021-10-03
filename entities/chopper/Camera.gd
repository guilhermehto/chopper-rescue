extends Camera

var initial_global_position: Vector3
var parent_transform: Transform

var target: Vector3

var default_following_speed: float = 20
var catch_up_following_speed: float = 100
var desired_distance: float
var current_speed: float = default_following_speed

func _ready() -> void:
	set_as_toplevel(true)
	initial_global_position = global_transform.origin
	desired_distance = 15

func _physics_process(delta: float) -> void:
	parent_transform = get_parent().global_transform
	target = parent_transform.origin + initial_global_position.rotated(Vector3.UP, get_parent().rotation.y)
	global_transform.origin.y = target.y
	var direction = (target - global_transform.origin).normalized()
	var desired_speed = default_following_speed if target.distance_to(global_transform.origin) < desired_distance else get_parent().linear_velocity.length()
	current_speed = lerp(current_speed, desired_speed, 1.5 * delta)
#	global_transform.origin += direction * current_speed * delta
	var weight = 1.5 if target.distance_to(global_transform.origin) < desired_distance else 2.5
	global_transform.origin = global_transform.origin.linear_interpolate(target, weight * delta)
	look_at(parent_transform.origin, Vector3.UP)

	#look_at_from_position(global_transform.origin, parent_transform.origin, Vector3.UP)
