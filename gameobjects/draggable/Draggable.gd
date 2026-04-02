extends CharacterBody3D

var blood_puddle_scene = preload("res://gameobjects/mess/BloodPuddle.tscn")
@onready var original_parent = get_parent()
var dragging = false

func _ready() -> void:
	$FallSound.play()
	$actor/AnimationPlayer.play("new_dead")

func drag(player_scene):
	await get_tree().physics_frame
	reparent(player_scene.neck)
	position.x = 0
	position.z = 0
	set_collision_mask_value(1, false)
	dragging = true
	$DragSound.play()
	$actor/AnimationPlayer.play("new_dead_dragging")
	

func _physics_process(delta: float) -> void:
	if not $DragBleedTimer.is_stopped() and dragging and $DragBleedDelay.is_stopped():
		$DragBleedDelay.start()
		if randi_range(1, 4) == 1:
			var blood_puddle = blood_puddle_scene.instantiate()
			blood_puddle.global_transform = global_transform
			blood_puddle.rotation.y = randf_range(0, 2 * PI)
			original_parent.add_child(blood_puddle)

func release():
	$DragSound.stop()
	$actor/AnimationPlayer.pause()
	await get_tree().physics_frame
	dragging = false
	set_collision_mask_value(1, true)
	reparent(original_parent)
