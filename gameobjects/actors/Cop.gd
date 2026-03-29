extends Actor
class_name Cop

@export var spawn_point : Node3D

func _ready() -> void:
	state = FREEZE

func stall(stall_time: float):
	$StallTimer.start(stall_time)
	state = STALLED


func _on_stall_timer_timeout() -> void:
	state = PATROL

func activate():
	global_transform = spawn_point.global_transform
	_on_navigation_agent_3d_target_reached()
