extends CharacterBody3D

enum {FREEZE, MOVE, CLEAN, DIE}

const SPEED = 5.0

const LOOK_SENSITIVITY = 0.005
const ACCEL = 1.0

var state = MOVE

@onready var neck = $Neck
@onready var camera = $Neck/Camera3D


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
			if Input.is_action_just_pressed("action1"):
				var interaction = $Neck/Camera3D/InteractRay.get_collider()
				if interaction and interaction is InteractTrigger:
					match interaction.interaction_type:
						"clean":
							state = CLEAN
					print_debug("I INTERACTED")
		CLEAN:
			velocity = Vector3.ZERO
			if Input.is_action_just_released("action1"):
				state = MOVE
	move_and_slide()
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion and state != CLEAN:
			neck.rotate_y(-event.relative.x * LOOK_SENSITIVITY)
			camera.rotate_x(-event.relative.y * LOOK_SENSITIVITY)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
