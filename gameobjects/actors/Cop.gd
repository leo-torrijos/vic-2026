extends Actor
class_name Cop

@export var spawn_point : Node3D
@export var dialogues : Dictionary[String, DialogueSequence] = {} ## "Saw blood" -> start respective DialogueSequence
var dialogue_director

func _ready() -> void:
	state = FREEZE
	var sequence = load("res://resources/dialogue/sequences/test_sequence/test_sequence.tres")

func stall(stall_time: float):
	$StallTimer.start(stall_time)
	state = STALLED


func _on_stall_timer_timeout() -> void:
	state = PATROL

func activate():
	global_transform = spawn_point.global_transform
	_on_navigation_agent_3d_target_reached()

func saw_something(what_I_saw:Node3D):
	print("I saw this:\n")
	print(what_I_saw)
	print("\n")
	print(what_I_saw.get_groups())
	dialogue_director = Global.current_level_director.get_node("DialogueDirector")
	
	if what_I_saw.is_in_group("Corpse"):
		dialogue_director.start_dialogue(dialogues["Saw corpse"])
	elif what_I_saw.is_in_group("BloodPuddle"):
		dialogue_director.start_dialogue(dialogues["Saw blood"])
