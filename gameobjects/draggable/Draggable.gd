extends CharacterBody3D

@onready var original_parent = get_parent()

func drag(player_scene):
	reparent(player_scene.neck)
	position.x = 0
	position.z = 0
	set_collision_mask_value(1, false)

func release():
	set_collision_mask_value(1, true)
	reparent(original_parent)
