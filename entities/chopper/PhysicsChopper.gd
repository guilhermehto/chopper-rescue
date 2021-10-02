extends RigidBody

#const COLLECTIVE_SPEED: float = 0.3 # how quickly the collective goes up and down
const COLLECTIVE_SPEED: float = 0.8 # how quickly the collective goes up and down
const MAX_ROTATION: float = deg2rad(20.0)

export var engine_force: float = 6000
export var tail_engine_force: float = 3000
export var yaw_force: float = 3000
export var pitch_force: float = 8000
export var roll_force: float = 2000

var collective: float = 0 setget _set_collective

func _integrate_forces(state: PhysicsDirectBodyState) -> void:
	
	if rotation.z >= MAX_ROTATION and angular_velocity.z > 0:
		angular_velocity.z = 0
		rotation.z = MAX_ROTATION
	elif rotation.z <= -MAX_ROTATION and angular_velocity.z < 0:
		angular_velocity.z = 0
		rotation.z = -MAX_ROTATION
	
	if rotation.x >= MAX_ROTATION and angular_velocity.x > 0:
		angular_velocity.x = 0
		rotation.x = MAX_ROTATION
	elif rotation.x <= -MAX_ROTATION and angular_velocity.x < 0:
		angular_velocity.x = 0
		rotation.x = -MAX_ROTATION
	
	
func _physics_process(delta: float) -> void:
	self.collective = collective + (float(Input.is_action_pressed("collective_up")) - float(Input.is_action_pressed("collective_down"))) * COLLECTIVE_SPEED * delta
	add_force(Vector3.UP * engine_force * collective, Vector3.ZERO)
	
	var pedal_rotation = Input.get_action_strength("pedal_left") - Input.get_action_strength("pedal_right")
	add_torque(global_transform.basis.y * yaw_force * pedal_rotation)
	
	var cyclic = Vector2(
		Input.get_action_strength("cyclic_backward") - Input.get_action_strength("cyclic_forward"),
		Input.get_action_strength("cyclic_right") - Input.get_action_strength("cyclic_left")
	)
	if rotation.z < MAX_ROTATION and rotation.z > -MAX_ROTATION:
		add_torque(-global_transform.basis.z * roll_force * cyclic.y)
	if rotation.x < MAX_ROTATION and rotation.x > -MAX_ROTATION:
		add_torque(global_transform.basis.x * pitch_force * cyclic.x)
	
#	var forward_force = Vector3.UP.dot(Vector3(0, rotation.x, 0))
	var forward_force = rotation.x / MAX_ROTATION
	print(forward_force)
	add_force(global_transform.basis.z.rotated(global_transform.basis.x, 0) * engine_force * 2 * forward_force, Vector3.ZERO)
	
	var side_force = -Vector3.UP.dot(Vector3(0, rotation.z, 0))
	add_force(Vector3.RIGHT.rotated(Vector3.UP, rotation.y) * engine_force * 2 * side_force, Vector3.ZERO)
	

func _set_collective(value: float) -> void:
	collective = clamp(value, 0, 1)
