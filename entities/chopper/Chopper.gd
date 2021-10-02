extends KinematicBody
class_name Chopper

const COLLECTIVE_SPEED: float = 0.1 # how quickly the collective goes up and down
const ROTATION_SPEED: float = 0.5
const PEDAL_ROTATION_SPEED: float = 2.0
const GRAVITY: float = 20.0
# might need some rotational constraints

export var engine_force: float = 1

var collective: float = 0 setget _set_collective


func _physics_process(delta: float) -> void:
	self.collective = collective + (float(Input.is_action_pressed("collective_up")) - float(Input.is_action_pressed("collective_down"))) * COLLECTIVE_SPEED * delta
	
	var move_rotation = Vector2(
		Input.get_action_strength("cyclic_forward") - Input.get_action_strength("cyclic_backward"),
		Input.get_action_strength("cyclic_right") - Input.get_action_strength("cyclic_left")
	)
	
	var pedal_rotation = Input.get_action_strength("pedal_right") - Input.get_action_strength("pedal_left")
	
	var rotation_x = deg2rad(move_rotation.x * 180)
	var rotation_y = deg2rad(sign(pedal_rotation) * 180)
	var rotation_z = deg2rad(move_rotation.y * 180)
	
	if move_rotation.x != 0 and abs(abs(rotation.x) - abs(rotation_x)) > 0.2:
		global_rotate(global_transform.basis.x, ROTATION_SPEED * delta * sign(-move_rotation.x))
	
	if move_rotation.y != 0 and abs(abs(rotation.z) - abs(rotation_z)) > 0.2:
		global_rotate(global_transform.basis.z, ROTATION_SPEED * delta * sign(-move_rotation.y))
	
	if pedal_rotation != 0:
		global_rotate(global_transform.basis.y, PEDAL_ROTATION_SPEED * delta * sign(-pedal_rotation))
	
	var forward_vector = Vector3(0, 0, rotation_degrees.x / 90 * 0.2).rotated(Vector3.UP, rotation.y)
	var sideways_vector = -Vector3(rotation_degrees.z / 90 * 0.2, 0, 0).rotated(Vector3.UP, rotation.z)
	
	print(forward_vector)
	
	move_and_collide((global_transform.basis.y * collective * engine_force) + forward_vector + sideways_vector + (Vector3.DOWN * GRAVITY) * delta)

func _set_collective(value: float) -> void:
	collective = clamp(value, 0, 1)
	
