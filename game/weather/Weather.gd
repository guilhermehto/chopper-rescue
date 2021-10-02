extends Node
class_name Weather

var helicopter: Helicopter
var noise: OpenSimplexNoise

func initialize(helicopter: Helicopter) -> void:
	self.helicopter = helicopter
	set_process(true)

func deactivate() -> void:
	set_process(false)

func _ready() -> void:
	randomize()
	set_process(false)
	
	noise = OpenSimplexNoise.new()

	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8

func _physics_process(delta: float) -> void:
	var noise_value = noise.get_noise_2d(helicopter.global_transform.origin.x, helicopter.global_transform.origin.y)
	helicopter.apply_impulse(Vector3.ZERO, noise_value * helicopter.global_transform.basis.x * 1000)
