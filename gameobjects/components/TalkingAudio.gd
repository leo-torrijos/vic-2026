extends AudioStreamPlayer3D
class_name TalkingAudio

signal finished_speaking
	
func _ready():
	finished.connect(_on_finished)

func _on_finished():
	print("Audio finished")  # DEBUG
	finished_speaking.emit()
