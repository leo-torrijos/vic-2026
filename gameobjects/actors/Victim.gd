extends Actor
class_name Victim

var corpse_scene = preload("res://gameobjects/draggable/Corpse.tscn")

signal death

func die():
	death.emit()
	
	var corpse = corpse_scene.instantiate()
	corpse.global_transform = global_transform
	get_parent().add_child(corpse)
	print_debug("DEAD")
	queue_free()
