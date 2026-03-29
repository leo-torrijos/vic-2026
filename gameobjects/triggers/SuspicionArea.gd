extends Area3D

var current_cop = null

@export var suspicion_amount = 1.0

func _physics_process(delta: float) -> void:
	if current_cop:
		$Sightline.target_position = to_local(current_cop.global_position + Vector3(0, 0.1, 0))
		$Sightline.force_raycast_update()
		if $AdditionTimer.is_stopped() and not $Sightline.is_colliding():
			$AdditionTimer.start()

func _on_body_entered(body: Node3D) -> void:
	if current_cop == null:
		current_cop = body


func _on_body_exited(body: Node3D) -> void:
	if not has_overlapping_bodies():
		current_cop = null
		$AdditionTimer.stop()


func _on_addition_timer_timeout() -> void:
	Global.add_suspicion(suspicion_amount)
