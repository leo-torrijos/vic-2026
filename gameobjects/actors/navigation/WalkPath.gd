extends Node3D

### Path thingy for Actors to walk along.

@export var new_pos_time = 0.1
@export var navigator : Node3D
# TODO: actually implement "finishing" paths
## Whether this path should be looped or only be travelled once
@export var loop_path = true

var current_index = -1

# Add Node3Ds as children
var follow_points = []
var current_follow_goal : Node3D

## Emitted when "loop_path" is false and the entire path has been walked.
signal path_completed

func _ready():
	for i in get_children():
		if i is Node3D:
			follow_points.append(i)
	assert(follow_points.size() > 0)
	#navigator.connect("target_reached", _on_target_reached)
	navigator.follow_director = self
	_on_target_reached()
	#hide()

func _on_target_reached():
	if new_pos_time > 0.0:
		await get_tree().create_timer(new_pos_time).timeout
	current_index += 1
	if current_index >= follow_points.size():
		if loop_path:
			current_index = 0
		else:
			emit_signal("path_completed")
			return
	current_follow_goal = follow_points[current_index]
	#print("LET'S GO")
	#print(current_follow_goal.global_position)
	if navigator:
		navigator.patrol(current_follow_goal.global_position)
