extends CharacterBody3D
class_name Player

enum {FREEZE, MOVE, CLEAN, DRAG, DIE}

const SPEED = 5.0

const LOOK_SENSITIVITY = 0.005
const ACCEL = 1.0

const CROSSHAIR_TEXTURES = {
	"default" : preload("res://assets/gui/temp_crosshair_default.png"),
	"inspect" : preload("res://assets/gui/temp_crosshair_inspect.png"),
	"talk" : preload("res://assets/gui/temp_crosshair_talk.png"),
	"kill" : preload("res://assets/gui/temp_crosshair_kill.png"),
	"clean" : preload("res://assets/gui/temp_crosshair_clean.png"),
	"pickup" : preload("res://assets/gui/temp_crosshair_pickup.png"),
	"putdown" : preload("res://assets/gui/temp_crosshair_putdown.png"),
}
const INSPECT_TEXTURES = {
	"e" : preload("res://assets/gui/inspect_notif_e.png"),
	"lc" : preload("res://assets/gui/inspect_notif_lc.png"),
	"check" : preload("res://assets/gui/inspect_notif_check.png"),
}

var state = MOVE

@onready var neck = $Neck
@onready var camera = $Neck/Camera3D
@onready var player_ui = $PlayerUI
@onready var player_hand = $Neck/Camera3D/WeaponBone
@onready var crosshair: TextureRect = $PlayerUI/Control/CenterContainer/Crosshair
@onready var inspect_indicator: TextureRect = $PlayerUI/InspectIndicator

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
			
			# Set default crosshair texture; override later if necessary
			crosshair.texture = CROSSHAIR_TEXTURES.default
			
			# Action (i.e. using item, cleaning)
			if handheld and handheld is Weapon and handheld.get_node("KillRay").get_collider():
				crosshair.texture = CROSSHAIR_TEXTURES.kill
				if Input.is_action_just_pressed("action1"):
					current_interaction = handheld.get_node("KillRay").get_collider()
					if current_interaction.interaction_type == "kill":
						current_interaction.get_parent().die()
			else:
				current_interaction = $Neck/Camera3D/InteractRay.get_collider()
				if current_interaction and current_interaction is InteractTrigger:
					if current_interaction.inspectable:
						inspect_indicator.texture = INSPECT_TEXTURES.e
						inspect_indicator.show()
					elif current_interaction.inspected:
						inspect_indicator.texture = INSPECT_TEXTURES.check
						inspect_indicator.show()
					else:
						inspect_indicator.hide()
					
					# Inspect handling
					if Input.is_action_pressed("interact") and current_interaction.inspectable:
						inspect_indicator.texture = INSPECT_TEXTURES.lc
						inspect_indicator.show()
						crosshair.texture = CROSSHAIR_TEXTURES.inspect
						if Input.is_action_just_pressed("action1"):
							$InspectHandler.inspect(current_interaction)
					else:
						match current_interaction.interaction_type:
							"clean":
								if not hands_full:
									crosshair.texture = CROSSHAIR_TEXTURES.clean
									if Input.is_action_just_pressed("action1"):
										current_interaction.get_parent().clean(self)
										state = CLEAN
										hands_full = true
										$CleaningSuspicionArea/CollisionShape3D.set_deferred("disabled", false)
							"pickup":
								if not hands_full:
									crosshair.texture = CROSSHAIR_TEXTURES.pickup
									if Input.is_action_just_pressed("action1"):
										handheld = current_interaction.get_parent().collected_object.instantiate()
										handheld.stored_pickup = current_interaction.get_parent()
										current_interaction.get_parent().get_parent().remove_child(handheld.stored_pickup)
										player_hand.add_child(handheld)
										hands_full = true
							"put_in_holder":
								if hands_full and handheld != null:
									crosshair.texture = CROSSHAIR_TEXTURES.putdown
									if Input.is_action_just_pressed("action1"):
										current_interaction.get_parent().place_object(handheld.stored_pickup)
										handheld.queue_free()
										hands_full = false
							"take_from_holder":
								if hands_full and handheld != null:  # Swap weapons
									crosshair.texture = CROSSHAIR_TEXTURES.putdown
									if Input.is_action_just_pressed("action1"):
										var temp_handheld = current_interaction.get_parent().yield_object()
										temp_handheld.stored_pickup = current_interaction.get_parent().held_object
										current_interaction.get_parent().place_object(handheld.stored_pickup)
										handheld.queue_free()
										handheld = temp_handheld
										player_hand.add_child(handheld)
								elif not hands_full:
									crosshair.texture = CROSSHAIR_TEXTURES.pickup
									if Input.is_action_just_pressed("action1"):
										handheld = current_interaction.get_parent().yield_object()
										handheld.stored_pickup = current_interaction.get_parent().held_object
										player_hand.add_child(handheld)
										hands_full = true
							"drag":
								if not hands_full:
									crosshair.texture = CROSSHAIR_TEXTURES.pickup
									if Input.is_action_just_pressed("action1") and global_position.distance_to(current_interaction.global_position) < 1.0:
										hands_full = true
										state = DRAG
										current_interaction.get_parent().drag(self)
							"stall":
								crosshair.texture = CROSSHAIR_TEXTURES.talk
								if Input.is_action_just_pressed("action1"):
									var cop = current_interaction.get_parent()
									if cop.state != Cop.STALLED:
										# TODO: allow different stall times for info/objects
										current_interaction.get_parent().stall(1.0)
									else:
										# TODO: handle attempts to stall when cop is already stalled
										pass
				else:
					inspect_indicator.hide()
		CLEAN:
			crosshair.texture = CROSSHAIR_TEXTURES.clean
			velocity = Vector3.ZERO
			if Input.is_action_just_released("action1"):
				state = MOVE
				hands_full = false
				if current_interaction:
					current_interaction.get_parent().cancel_clean()
					$CleaningSuspicionArea/CollisionShape3D.set_deferred("disabled", true)
		DRAG:
			crosshair.texture = CROSSHAIR_TEXTURES.putdown
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
				if current_interaction:
					current_interaction.get_parent().release()
				state = MOVE
				hands_full = false
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
	hands_full = false
	# TODO: chance to say something on clean?
	$CleaningSuspicionArea/CollisionShape3D.set_deferred("disabled", true)
