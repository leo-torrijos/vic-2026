extends Node3D

## Raises suspicion if dirty.
var dirty = false

# VALID INPUTS:
# generic
# wipe
@export var mess_type = "generic"
@export var time_to_clean = 2.0

var player

func _ready() -> void:
	$CleanTimer.wait_time = time_to_clean
	#get_dirty()

func clean(player_scene):
	$CleanTimer.start()
	player = player_scene
	
	
func cancel_clean():
	$CleanTimer.stop()



func _on_clean_timer_timeout() -> void:
	player.done_cleaning()
	dirty = false
	$SuspicionArea.set_deferred("monitorable", false)
	$InteractTrigger.set_deferred("monitorable", false)
	$CleanIcon.hide()
	$AnimationPlayer.play("idle")


func get_dirty():
	if not dirty:
		dirty = true
		$SuspicionArea.set_deferred("monitorable", true)
		$InteractTrigger.set_deferred("monitorable", true)
		$CleanIcon.show()
		$AnimationPlayer.play("damage")
