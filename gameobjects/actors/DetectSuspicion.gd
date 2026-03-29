extends Area3D

var nearby_messes = []
var noticed_messes = []
var mess_index = 0

# cycle between valid targets to ensure sightline
func _physics_process(delta: float) -> void:
	if $CheckSurroundingsTimer.is_stopped():
		if nearby_messes.is_empty():
			return
		if mess_index >= nearby_messes.size():
			$CheckSurroundingsTimer.start()
			mess_index = 0
			return
		$Sightline.look_at(nearby_messes[mess_index].global_position)
		#$Sightline.cast
		$Sightline.force_raycast_update()
		#if $Sightline.is_colliding():
			
		mess_index += 1
		print(mess_index)
		

func _on_area_entered(area: Area3D) -> void:
	if not area in nearby_messes:
		nearby_messes.append(area)
	print(nearby_messes)


func _on_area_exited(area: Area3D) -> void:
	nearby_messes.erase(area)
