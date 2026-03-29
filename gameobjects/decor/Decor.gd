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
	$SuspicionArea/CollisionShape3D.set_deferred("disabled", false)
	$InteractTrigger/CollisionShape3D.set_deferred("disabled", true)
	$CleanIcon.hide()
	$AnimationPlayer.play("idle")


func get_dirty():
	if not dirty:
		dirty = true
		$SuspicionArea/CollisionShape3D.set_deferred("disabled", true)
		$InteractTrigger/CollisionShape3D.set_deferred("disabled", false)
		$CleanIcon.show()
		$AnimationPlayer.play("damage")
