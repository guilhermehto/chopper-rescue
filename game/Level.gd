extends Spatial

onready var helicopter: Helicopter = $PhysicsChopper
onready var weathers: Node = $Weathers
onready var timer: Timer = $Timer
onready var gui: GUI = $GUI

export var min_weather_time: float = 10
export var max_weather_time: float = 25

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
	var old_weather = active_weather
	
	self.active_weather = weathers.get_child(randi() % weathers.get_child_count())
	active_weather.initialize(helicopter)
	
	if old_weather != null and old_weather.weather_name == active_weather.weather_name:
		gui.notify("%s weather continues!" % active_weather.weather_name)
	else:
		gui.notify("%s weather started!" % active_weather.weather_name)
	

func _reset_timer() -> void:
	timer.wait_time = rand_range(min_weather_time, max_weather_time)
	timer.start()
