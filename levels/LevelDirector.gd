extends Node3D


## State Enum
enum {
	INTRO,  ## Opening cutscene
	CALM,  ## Planning phase; ends with murder
	MURDER,
	CLEANUP,  ## Cleanup phase; ends with cops' arrival
	INVESTIGATION,  ## Investigation phase; ends with cops finishing their route
	WIN,  ## Outro cutscene (if you win)
	LOSE  ## Outro cutscene (if you lose)
}

@export var cleanup_time = 20.0

var phase = 0

const SUSPICION_LIMIT = 100
#var state = INTRO
var suspicion = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CleanupTimer.wait_time = cleanup_time


func next_phase():
	phase += 1
	# TODO: could use enum with these
	match phase:
		INTRO:
			pass
		CALM: # Calm (Scope Out)
			pass
		MURDER: # Murder
			print_debug("YOU KILLED THEM...")
			pass
		CLEANUP: # Cleanup
			print_debug("Cleanup!")
			pass
		INVESTIGATION: # Investigation
			print_debug("Investigation begins. POLICE INCOMING!")
		WIN: # Win
			pass
		LOSE: # Lose :(
			pass

#func _physics_process(_delta: float) -> void:
	#if suspicion >= SUSPICION_LIMIT:
		#game_over()


## Intro -> Planning: Cutscene stuff
## Planning -> Cleanup: Victim Actor emits signal on death
# TODO: connect this to victim dying (current only one)
# NOTE: Make sure if multiple victims are added this is improved
func _on_victim_die():
	next_phase()
	$CleanupTimer.start()

## Cleanup -> Investigation: Timer runs out
func _on_cleanup_timer_timeout() -> void:
	next_phase()
	# TODO: spawn cops, set routes

## Investigation -> Win: All cops finish routes

## Investigation -> Lose: Suspicion hits maximum
func game_over() -> void:
	# TODO: loss cutscene
	pass
