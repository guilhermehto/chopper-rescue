extends Node
class_name Weather

export var strength: = 0.0
export var weather_name: = ""

onready var texture: TextureRect = $Control/TextureRect

var helicopter: Helicopter
var noise: OpenSimplexNoise

var offset := 0.0
var image_texture := ImageTexture.new()
var is_active := false

func initialize(helicopter: Helicopter) -> void:
	self.helicopter = helicopter
	set_physics_process(true)
	is_active = true
	Debug.connect("started_debugging", self, "_on_started_debugging")
	Debug.connect("stopped_debugging", self, "_on_stopped_debugging")

func deactivate() -> void:
	set_physics_process(false)
	is_active = false
	Debug.disconnect("started_debugging", self, "_on_started_debugging")
	Debug.disconnect("stopped_debugging", self, "_on_stopped_debugging")

func _ready() -> void:
	randomize()
	set_physics_process(false)
	
	noise = OpenSimplexNoise.new()

	noise.seed = randi()
	noise.octaves = 3
	noise.period = 20.0
	noise.persistence = 0.5
	
func _physics_process(delta: float) -> void:
	if helicopter.is_landed:
		return
	
	offset += delta
	var noise_value = noise.get_noise_2d(helicopter.global_transform.origin.x + offset, helicopter.global_transform.origin.y + offset)
	helicopter.apply_impulse(Vector3.ZERO, noise_value * helicopter.global_transform.basis.x * strength)

func _on_started_debugging() -> void:
	image_texture.create_from_image(noise.get_image(200, 200))
	texture.texture = image_texture

func _on_stopped_debugging() -> void:
	texture.texture = null
