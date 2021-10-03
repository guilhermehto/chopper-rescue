extends Spatial

signal game_ended

onready var helicopter: Helicopter = $PhysicsChopper
onready var weathers: Node = $Weathers
onready var timer: Timer = $Timer
onready var map: Map = $Map
onready var gui: GUI = $GUI

export var rescuee_group_scene: PackedScene
export var min_weather_time: float = 10
export var max_weather_time: float = 25

var active_weather
var lost_groups: int = 0

func _ready() -> void:
	randomize()
	timer.connect("timeout", self, "_on_timer_timeout")
	_reset_timer()
	_select_random_weather()
	_spawn_new_group()

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

func _on_PhysicsChopper_died() -> void:
	emit_signal("game_ended")

func _on_rescuee_group_died() -> void:
	lost_groups += 1
	if lost_groups == 5:
		emit_signal("game_ended")
	_spawn_new_group()

func _on_rescuee_group_rescued() -> void:
	_spawn_new_group()

func _reset_timer() -> void:
	timer.wait_time = rand_range(min_weather_time, max_weather_time)
	timer.start()

func _spawn_new_group() -> void:
	var possible_positions = map.get_rescue_points()
	var position = possible_positions[randi() % possible_positions.size()]
	var rescuee_group = rescuee_group_scene.instance()
	rescuee_group.global_transform.origin = position.global_transform.origin
	map.add_child(rescuee_group)
	rescuee_group.connect("rescuee_group_died", self, "_on_rescuee_group_died")
	rescuee_group.connect("groupe_rescued", self, "_on_rescuee_group_rescued")
