extends Spatial

onready var helicopter: Helicopter = $PhysicsChopper
onready var weathers: Node = $Weathers
onready var timer: Timer = $Timer

export var min_weather_time: float = 20
export var max_weather_time: float = 45

var active_weather

func _ready() -> void:
	randomize()
	timer.connect("timeout", self, "_on_timer_timeout")
	_reset_timer()
	_select_random_weather()

func _on_timer_timeout() -> void:
	_reset_timer()
	_select_random_weather()

func _select_random_weather() -> void:
	self.active_weather = weathers.get_child(randi() % weathers.get_child_count())
	active_weather.initialize(helicopter)

func _reset_timer() -> void:
	timer.wait_time = rand_range(min_weather_time, max_weather_time)
	timer.start()
