extends Node3D

# VALID INPUTS:
# generic
# wipe
@export var mess_type = "generic"
@export var time_to_clean = 1.5


var player

func _ready() -> void:
	$CleanTimer.wait_time = time_to_clean

func clean(player_scene):
	$CleanTimer.start()
	player = player_scene
	
func cancel_clean():
	$CleanTimer.stop()


func _on_clean_timer_timeout() -> void:
	player.done_cleaning()
	queue_free()
