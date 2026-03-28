extends CharacterBody3D

enum {FREEZE, MOVE, CLEAN, DRAG, DIE}

const SPEED = 5.0

const LOOK_SENSITIVITY = 0.005
const ACCEL = 1.0

var state = MOVE

@onready var neck = $Neck
@onready var camera = $Neck/Camera3D
@onready var player_ui = $PlayerUI
@onready var player_hand = $Neck/Camera3D/WeaponBone

var current_interaction = null
var hands_full = false
var handheld = null


func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _physics_process(delta: float) -> void:
	match state:
		FREEZE:
			velocity = Vector3.ZERO
		MOVE:
			# Add the gravity.
			if not is_on_floor():
				velocity += get_gravity() * delta

			var input_dir = Input.get_vector("left", "right", "forward", "backward")
			var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
			if direction:
					#$CameraAnim.play("run")
				#else:
					#$CameraAnim.play("walk")
				velocity.x = lerp(velocity.x, direction.x * SPEED, ACCEL)
				velocity.z = lerp(velocity.z, direction.z * SPEED, ACCEL)
				
			else:
				velocity.x = move_toward(velocity.x, 0.0, ACCEL)
				velocity.z = move_toward(velocity.z, 0.0, ACCEL)
			
			# Action (i.e. using item, cleaning)
			if handheld and handheld is Weapon and handheld.get_node("KillRay").get_collider():
				if Input.is_action_just_pressed("action1"):
					current_interaction = handheld.get_node("KillRay").get_collider()
					if current_interaction.interaction_type == "kill":
						current_interaction.get_parent().die()
			else:
				current_interaction = $Neck/Camera3D/InteractRay.get_collider()
				if current_interaction and current_interaction is InteractTrigger:
					match current_interaction.interaction_type:
						"clean":
							if Input.is_action_just_pressed("action1"):
								current_interaction.get_parent().clean(self)
								state = CLEAN
						"pickup":
							if Input.is_action_just_pressed("action1") and not hands_full:
								handheld = current_interaction.get_parent().collected_object.instantiate()
								handheld.stored_pickup = current_interaction.get_parent()
								current_interaction.get_parent().get_parent().remove_child(handheld.stored_pickup)
								player_hand.add_child(handheld)
								hands_full = true
						"put_in_holder":
							if Input.is_action_just_pressed("action1") and hands_full:
								current_interaction.get_parent().place_object(handheld.stored_pickup)
								handheld.queue_free()
								hands_full = false
						"take_from_holder":
							if Input.is_action_just_pressed("action1") and not hands_full:
								handheld = current_interaction.get_parent().yield_object()
								handheld.stored_pickup = current_interaction.get_parent().held_object
								player_hand.add_child(handheld)
								hands_full = true
						"drag":
							if Input.is_action_just_pressed("action1"):
								current_interaction.get_parent().drag(self)
								state = DRAG
		CLEAN:
			velocity = Vector3.ZERO
			if Input.is_action_just_released("action1"):
				state = MOVE
				if current_interaction:
					current_interaction.get_parent().cancel_clean(self)
		DRAG:
			# For dragging stuff, probably corpses.
			# Ratchet fix: Use "none" in input map to denote no input
			var input_dir = Input.get_vector("left", "right", "none", "backward")
			var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
			if direction:
					#$CameraAnim.play("run")
				#else:
					#$CameraAnim.play("walk")
				velocity.x = lerp(velocity.x, direction.x * SPEED * 0.5, ACCEL)
				velocity.z = lerp(velocity.z, direction.z * SPEED * 0.5, ACCEL)
				
			else:
				velocity.x = move_toward(velocity.x, 0.0, ACCEL)
				velocity.z = move_toward(velocity.z, 0.0, ACCEL)
			
			# Release draggable
			if Input.is_action_just_released("action1"):
				state = MOVE
				if current_interaction:
					current_interaction.get_parent().release()
	move_and_slide()
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion and state != CLEAN:
			neck.rotate_y(-event.relative.x * LOOK_SENSITIVITY)
			camera.rotate_x(-event.relative.y * LOOK_SENSITIVITY)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func done_cleaning():
	state = MOVE
	# TODO: chance to say something on clean?
