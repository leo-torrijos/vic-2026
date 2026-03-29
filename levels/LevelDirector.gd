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

@export var cleanup_time : float = 20.0

var phase = 0

const SUSPICION_LIMIT = 100
#var state = INTRO
var suspicion = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.current_level_director = self
	$CleanupTimer.wait_time = cleanup_time
	next_phase()
	
	# Actors setup
	for i in $Actors.get_children():
		# provide nav mesh to aid in random movement while death tweaking
		i.nav_mesh = $Actors/Victim/NavigationAgent3D.get_navigation_map()

func next_phase(forced_state=0):
	if forced_state > 0:
		phase = forced_state
	phase += 1
	match phase:
		INTRO:
			pass
		CALM: # Calm (Scope Out)
			$Music/CalmMusic.play()
		MURDER: # Murder
			$Music/CalmMusic.stop()
			$Music/MurderSting.play()
			print_debug("YOU KILLED THEM...")
		CLEANUP: # Cleanup
			print_debug("Cleanup!")
			get_node("Paths/WalkPathCop").show()
			pass
		INVESTIGATION: # Investigation
			get_node("Actors/Cop").activate()
			$SuspicionUI.show()
			print_debug("Investigation begins. POLICE INCOMING!")
		WIN: # Win
			print_debug("you won!")
			$Win.show()
		LOSE: # Lose :(
			print_debug("Busted!")
			$GameOver.show()

#func _physics_process(_delta: float) -> void:
	#if suspicion >= SUSPICION_LIMIT:
		#game_over()
func get_current_phase():
	return phase

## Intro -> Planning: Cutscene stuff
## Planning -> Cleanup: Victim Actor emits signal on death
# TODO: connect this to victim dying (current only one)
# NOTE: Make sure if multiple victims are added this is improved
func _on_victim_death() -> void:
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

func update_suspicion_ui(total_suspicion):
	$SuspicionUI/Control/SuspicionMeter.value = Global.total_suspicion
	if Global.total_suspicion >= 100:
		next_phase(LOSE)


func _on_victim_about_to_die() -> void:
	if phase < MURDER:
		next_phase()


func _on_walk_path_cop_path_completed() -> void:
	if phase != LOSE:
		next_phase(WIN)
