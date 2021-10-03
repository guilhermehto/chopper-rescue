extends KinematicBody
class_name Rescuee

signal picked_up

onready var animation_player: AnimationPlayer = $Mesh/RescueeSkeleton/Rescuee/AnimationPlayer

export var move_speed: float = 3.0

var target: Transform

func follow_target(new_target: Transform) -> void:
	target = new_target
	set_physics_process(true)
	animation_player.play("Run")

func stop_following_target() -> void:
	set_physics_process(false)
	animation_player.stop()

func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	var direction = (target.origin - global_transform.origin).normalized()
	
	var move = direction * move_speed
	
	move_and_slide(move, Vector3.UP)
