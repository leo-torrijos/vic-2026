extends Actor
class_name Victim

signal death

func die():
	death.emit()
	print("DEAD")
