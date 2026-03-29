extends Control


#const Level1Scene = preload("res://levels/Level1.tscn")
#const Level2Scene = preload("res://levels/Level2.tscn")


func _on_level_1_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/Level1.tscn")


func _on_level_2_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/Level2.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
