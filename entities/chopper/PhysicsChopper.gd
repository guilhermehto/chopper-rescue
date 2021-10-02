extends RigidBody

onready var mesh: Spatial = $ChopperMesh

const COLLECTIVE_SPEED: float = 0.8 # how quickly the collective goes up and down
const MAX_ROTATION: float = deg2rad(30)

export var engine_force: float = 10000
export var linear_force: float = 6000
export var tail_engine_force: float = 3000
export var rotate_speed: float = .5

var collective: float = 0 setget _set_collective

func _physics_process(delta: float) -> void:
	self.collective = collective + (float(Input.is_action_pressed("collective_up")) - float(Input.is_action_pressed("collective_down"))) * COLLECTIVE_SPEED * delta
	add_force(global_transform.basis.y * engine_force * collective, Vector3.ZERO)
	
	var pedal_rotation = Input.get_action_strength("pedal_left") - Input.get_action_strength("pedal_right")
	add_torque(global_transform.basis.y * tail_engine_force * pedal_rotation)
	
	var cyclic = Vector2(
		Input.get_action_strength("cyclic_backward") - Input.get_action_strength("cyclic_forward"),
		Input.get_action_strength("cyclic_right") - Input.get_action_strength("cyclic_left")
	)
	
	add_force(global_transform.basis.z.rotated(global_transform.basis.x, 0) * linear_force * cyclic.x, Vector3.ZERO)
	
	add_force(Vector3.RIGHT.rotated(Vector3.UP, rotation.y) * linear_force * cyclic.y, Vector3.ZERO)
	
	if cyclic.x != 0:
		mesh.rotation.x = clamp(mesh.rotation.x + cyclic.x * rotate_speed * delta, -MAX_ROTATION, MAX_ROTATION)
	elif mesh.rotation.x != 0:
		if mesh.rotation.x > 0:
			mesh.rotation.x = max(0, mesh.rotation.x - rotate_speed * delta)
		else:
			mesh.rotation.x = min(0, mesh.rotation.x + rotate_speed * delta)
	
	if cyclic.y != 0:
		mesh.rotation.z = clamp(mesh.rotation.z + -cyclic.y * rotate_speed * delta, -MAX_ROTATION, MAX_ROTATION)
	elif mesh.rotation.z != 0:
		if mesh.rotation.z > 0:
			mesh.rotation.z = max(0, mesh.rotation.z - rotate_speed * delta)
		else:
			mesh.rotation.z = min(0, mesh.rotation.z + rotate_speed * delta)
	
	

func _set_collective(value: float) -> void:
	collective = clamp(value, 0, 1)
