extends Spatial
class_name Compass

onready var compass_mesh: Spatial = $Compass
onready var waypoint: Spatial = $Compass/Waypoint

var target: Vector3
var active_waypoint: Spatial

func _process(delta: float) -> void:
	compass_mesh.rotation = Vector3(rotation.x, rotation.y, -get_parent().global_transform.basis.get_euler().y)
	if target != null:
		var direction = (target - get_parent().global_transform.origin).normalized()
		var v2_direction = Vector2(direction.x, direction.z)
		waypoint.transform.origin = Vector3(v2_direction.x * 0.6, -v2_direction.y  * 0.6, waypoint.transform.origin.z)

func _on_Timer_timeout() -> void:
	waypoint.visible = !waypoint.visible
