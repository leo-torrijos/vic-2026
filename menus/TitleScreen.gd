extends Control


const Level1Scene = preload("res://levels/Level1.tscn")
const Level2Scene = preload("res://levels/Level2.tscn")


func _on_level_1_button_pressed() -> void:
	add_sibling(Level1Scene.instantiate())
	queue_free()


func _on_level_2_button_pressed() -> void:
	add_sibling(Level2Scene.instantiate())
	queue_free()
