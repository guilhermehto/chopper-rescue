extends RigidBody
class_name Helicopter

signal landing_status_changed(is_landed)
signal passenger_boarded(carrying, capacity)
signal rescuee_unboarded(carrying, capacity)

onready var mesh: Spatial = $ChopperMesh
onready var compass: Spatial = $Camera/Compass
onready var fuel_indicator: Spatial = $Camera/FuelIndicator
onready var door_audio: DoorAudio = $DoorAudio
onready var timer: Timer = $Timer

signal died

const COLLECTIVE_SPEED: float = 0.8 # how quickly the collective goes up and down
const MAX_ROTATION: float = deg2rad(30)

export var engine_force: float = 17500
export var linear_force: float = 20000
export var tail_engine_force: float = 5000
export var rotate_speed: float = .5
export var max_fuel_time: float = 60
export var died_signal_timer: float = 5.0
export var rescuee_capacity: int = 4
export var crash_scene: PackedScene

var collective: float = 0 setget _set_collective
var fuel_time: float = max_fuel_time setget _set_fuel_time
var dead: bool = false
var is_landed: bool = true
var rescuees_being_carried: int

func unboard_rescuee() -> void:
	if rescuees_being_carried == 0:
		return
	rescuees_being_carried -= 1
	emit_signal("rescuee_unboarded", rescuees_being_carried, rescuee_capacity)
	door_audio.play_unboarding()

func _ready() -> void:
	fuel_indicator.max_fuel = max_fuel_time

func _physics_process(delta: float) -> void:
	if dead:
		return
	
	self.fuel_time -= delta
	
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
	
	_rotate_mesh(cyclic, delta)
	_check_fuel()
	
func _rotate_mesh(cyclic: Vector2, delta: float) -> void:
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

func _check_fuel() -> void:
	if fuel_time > 0:
		return
	_die()

func _die() -> void:
	if dead:
		return
	dead = true
	self.fuel_time = 0
	timer.wait_time = died_signal_timer
	timer.start()
	self.collective = 0

func _set_collective(value: float) -> void:
	collective = clamp(value, 0, 1)

func _on_Timer_timeout() -> void:
	emit_signal("died")

func _set_fuel_time(value: float) -> void:
	fuel_time = clamp(value, 0, max_fuel_time)
	fuel_indicator.fuel = fuel_time

func _on_PhysicsChopper_body_entered(body: Node) -> void:
	#This is broken if you're not moving forward or sideways
	if linear_velocity.length() > 15 and not dead:
		mesh.queue_free()
		var crash = crash_scene.instance()
		add_child(crash)
		crash.transform.origin = Vector3.ZERO
		crash.emitting = true
		_die()

func _on_LandingGear_landed() -> void:
	is_landed = true
	emit_signal("landing_status_changed", is_landed)

func _on_LandingGear_took_off() -> void:
	is_landed = false
	emit_signal("landing_status_changed", is_landed)

func _on_RescueArea_body_entered(body: Node) -> void:
	if body is Rescuee and rescuees_being_carried < rescuee_capacity:
		rescuees_being_carried += 1
		body.emit_signal("picked_up")
		body.queue_free()
		emit_signal("passenger_boarded", rescuees_being_carried, rescuee_capacity)
		door_audio.play_boarding()
