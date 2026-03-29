extends CanvasLayer

@export_file_path var next_level = "res://menus/TitleScreen.tscn"

func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()
