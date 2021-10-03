extends Node
class_name DoorAudio

onready var boarding: Node = $Boarding
onready var unboarding: Node = $Unboarding

func _ready() -> void:
	randomize()

func play_boarding() -> void:
	print("playig boarding")
	boarding.get_child(randi() % boarding.get_child_count()).play()

func play_unboarding() -> void:
	print("playig unboarding")
	unboarding.get_child(randi() % unboarding.get_child_count()).play()

func _on_PhysicsChopper_passenger_boarded(carrying, capacity) -> void:
	print("play")
	boarding.get_child(randi() % boarding.get_child_count()).play()

func _on_PhysicsChopper_rescuee_unboarded(carrying, capacity) -> void:
	unboarding.get_child(randi() % unboarding.get_child_count()).play()
