extends Node3D


## State Enum
enum {
	INTRO,  ## Opening cutscene
	PLANNING,  ## Planning phase; ends with murder
	CLEANUP,  ## Cleanup phase; ends with cops' arrival
	INVESTIGATION,  ## Investigation phase; ends with cops finishing their route
	WIN,  ## Outro cutscene (if you win)
	LOSS  ## Outro cutscene (if you lose)
}

var phase = 0

const SUSPICION_LIMIT = 100
var state = INTRO
var suspicion = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func next_phase():
	phase += 1
	# TODO: could use enum with these
	match phase:
		1: # Calm (Scope Out)
			pass
		2: # Murder
			pass
		3: # Cleanup
			pass
		4: # Investigation
			pass
		5: # Win
			pass

#func _physics_process(_delta: float) -> void:
	#if suspicion >= SUSPICION_LIMIT:
		#game_over()


## Intro -> Planning: Cutscene stuff
## Planning -> Cleanup: Victim Actor emits signal on death

## Cleanup -> Investigation: Timer runs out
func _on_cleanup_timer_timeout() -> void:
	state = INVESTIGATION
	# TODO: spawn cops, set routes

## Investigation -> Win: All cops finish routes

## Investigation -> Lose: Suspicion hits maximum
func game_over() -> void:
	# TODO: loss cutscene
	pass
