extends Node

class_name DialogueDirector

@export var speakers : Dictionary[String, Node] = {}  # Who's saying what lol
var current_sequence: DialogueSequence
var index = 0
var is_dialogue_taking_place = false

func _ready():
	#register_speaker("eldidi", get_node("../Player"))
	#register_speaker("Fake policeman", get_node("../FakePoliceman"))
	var sequence = load("res://resources/dialogue/sequences/test_sequence/test_sequence.tres")
	start_dialogue(sequence)

func register_speaker(speaker_name: String, node: Node):
	speakers[speaker_name] = node

func start_dialogue(sequence: DialogueSequence):
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
	_hide_subtitle()

func _display_subtitle(subtitle : String):
	var label : Label = Captions.get_child(0).get_child(0) # Temporary for testing dialogues
	label.text = subtitle
	#label.visible_ratio = 0.0;
	

func _hide_subtitle():
	print("")
