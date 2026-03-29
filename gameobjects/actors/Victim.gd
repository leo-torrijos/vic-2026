extends Actor
class_name Victim

var corpse_scene = preload("res://gameobjects/draggable/Corpse.tscn")
var blood_puddle_scene = preload("res://gameobjects/mess/BloodPuddle.tscn")

var taken_pills : Pills

signal about_to_die
signal death

func die(to_pills := false):
	$DamageDecor/CollisionShape3D.set_deferred("disabled", false)
	emit_signal("about_to_die")
	$DeathTimer.start()
	if to_pills:
		state = DIE_TO_PILLS
	else:
		state = DIE
	$InteractTrigger/CollisionShape3D.set_deferred("disabled", true)
	move_speed *= 3.0
	if follow_director:
		follow_director.queue_free()

func _physics_process(_delta: float) -> void:
	match state:
		IDLE, TAKE_PILLS:
			velocity = Vector3.ZERO
		PATROL, WALK_TO_PILLS:
			move()
			move_and_slide()
		DIE, DIE_TO_PILLS:
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
				if state == DIE_TO_PILLS:
					blood_puddle.get_node("Sprite3D").modulate = Color(0, 255, 0)
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


func pills_prompt_triggered(pills: Pills):
	taken_pills = pills
	state = WALK_TO_PILLS
	nav_agent.set_target_position(taken_pills.global_position)


func _on_detect_pills_area_entered(area: Area3D) -> void:
	area.get_node("CollisionShape3D").set_deferred("disabled", true)
	look_at(area.global_position)
	state = TAKE_PILLS
	$TakePillsTimer.start()


func _on_take_pills_timer_timeout() -> void:
	if taken_pills.poisoned:
		die(true)
	else:
		follow_director._on_target_reached()
		state = PATROL
