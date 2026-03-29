extends Actor
class_name Cop

@export var spawn_point : Node3D
var sequence

func _ready() -> void:
	state = FREEZE
	sequence = load("res://resources/dialogue/sequences/test_sequence/test_sequence.tres")

func stall(stall_time: float):
	$StallTimer.start(stall_time)
	state = STALLED


func _on_stall_timer_timeout() -> void:
	state = PATROL

func activate():
	global_transform = spawn_point.global_transform
	_on_navigation_agent_3d_target_reached()

func saw_something(what_I_saw:Node3D):
	print("I saw something\n")
	if what_I_saw.is_in_group("BloodPuddle"):
		Global.current_level_director.get_node("DialogueDirector").start_dialogue(sequence)
