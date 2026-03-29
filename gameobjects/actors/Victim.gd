extends Actor
class_name Victim

var corpse_scene = preload("res://gameobjects/draggable/Corpse.tscn")
var blood_puddle_scene = preload("res://gameobjects/mess/BloodPuddle.tscn")

signal death

func die():
	$DeathTimer.start()
	state = DIE
	$InteractTrigger/CollisionShape3D.set_deferred("disabled", true)
	move_speed *= 3.0
	follow_director.queue_free()

func _physics_process(delta: float) -> void:
	match state:
		IDLE:
			velocity = Vector3.ZERO
		PATROL:
			move()
			move_and_slide()
		DIE:
			if $MessRetargetTimer.is_stopped():
				if $DetectDecor.has_overlapping_bodies():
					print("I HATE THAT OBJECT")
					nav_agent.set_target_position($DetectDecor.get_overlapping_bodies().pick_random().global_position)
				else:
					var random_point = global_position + Vector3(randf_range(-2.0, 2.0), 0.0, randf_range(-2.0, 2.0))
					nav_agent.set_target_position(NavigationServer3D.map_get_closest_point(nav_mesh, random_point))
				$MessRetargetTimer.start()
				var blood_puddle = blood_puddle_scene.instantiate()
				blood_puddle.transform = transform
				blood_puddle.rotation.y = randf_range(0, 2 * PI)
				get_parent().add_child(blood_puddle)
			move()
			move_and_slide()

func _on_death_timer_timeout() -> void:
	death.emit()
	var corpse = corpse_scene.instantiate()
	corpse.global_transform = global_transform
	get_parent().add_child(corpse)
	print_debug("DEAD")
	queue_free()


func _on_damage_decor_body_entered(body: Node3D) -> void:
	body.get_parent().get_dirty()
