extends CanvasLayer
class_name PlayerUI

@onready var clean_progress: TextureProgressBar = $Control/CenterContainer/CleanProgress

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_clean_progress()

func update_clean_progress(new_value: float):
	clean_progress.value = new_value

func hide_clean_progress():
	clean_progress.hide()

func show_clean_progress():
	clean_progress.show()
