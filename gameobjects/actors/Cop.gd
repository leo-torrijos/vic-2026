extends Actor
class_name Cop


func stall(stall_time: float):
	$StallTimer.start(stall_time)
	state = STALLED


func _on_stall_timer_timeout() -> void:
	state = PATROL
