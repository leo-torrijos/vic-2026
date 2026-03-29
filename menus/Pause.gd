extends CanvasLayer

var currently_paused = false

func _ready() -> void:
	hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		set_pause()

func set_pause():
	currently_paused = not currently_paused
	get_tree().paused = currently_paused
	visible = currently_paused
	
	if currently_paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		visible = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		

func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void:
	get_tree().paused = false
	# TODO: need something to go to?
	#get_tree().change_scene_to_file("res://menus/MainMenu.tscn")


func _on_resume_pressed() -> void:
	currently_paused = true
	set_pause()
