extends Node

class_name DialogueDirector

@export var speakers : Dictionary[String, Node] = {}  # Who are our actors in scene (people that can talk in level)
var current_sequence: DialogueSequence
var index = 0
var is_dialogue_taking_place = false
var label : Label
var sequence : Resource

func _ready():
	#register_speaker("eldidi", get_node("../Player"))
	#register_speaker("Fake policeman", get_node("../FakePoliceman"))
	label = Captions.get_child(0).get_child(0)
	sequence = load("res://resources/dialogue/sequences/test_sequence/test_sequence.tres")
	#start_dialogue(sequence)

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		start_dialogue(sequence)

func register_speaker(speaker_name: String, node: Node):
	speakers[speaker_name] = node

func start_dialogue(sequence: DialogueSequence):
	label.visible = true
	if is_dialogue_taking_place:
		return
	current_sequence = sequence
	index = 0
	is_dialogue_taking_place = true
	_play_current_line()

func _play_current_line():
	if index >= current_sequence.lines.size():
		_end_dialogue()
		return

	var line : Voiceline = current_sequence.lines[index]
	var speaker_node = speakers[line.speaker]

	var talking_audio : TalkingAudio = speaker_node.get_node("TalkingAudio")

	# Play audio
	talking_audio.stream = line.audio_recording
	talking_audio.play()

	# Show subtitles
	_display_subtitle(line.speaker + ": " + line.subtitle)

	# Wait for finish
	talking_audio.finished_speaking.connect(_on_line_finished, CONNECT_ONE_SHOT)

func _on_line_finished():
	index += 1
	_play_current_line()

func _end_dialogue():
	is_dialogue_taking_place = false
	label.visible = false
	_hide_subtitle()

func _display_subtitle(subtitle : String):
	# Temporary for testing dialogues
	label.text = subtitle
	#label.visible_ratio = 0.0;
	

func _hide_subtitle():
	print("")
