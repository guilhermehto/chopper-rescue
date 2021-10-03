extends KinematicBody
class_name Rescuee

export var move_speed: float = 3.0

var target: Transform

func follow_target(new_target: Transform) -> void:
	target = new_target
	set_physics_process(true)

func stop_following_target() -> void:
	set_physics_process(false)

func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	var direction = (target.origin - global_transform.origin).normalized()
	
	var move = direction * move_speed
	
	move_and_slide(move, Vector3.UP)
