extends Node3D

## Raises suspicion if dirty.
var dirty = false

func get_dirty():
	dirty = true
	$SuspicionArea.set_deferred("monitorable", true)
