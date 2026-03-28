extends CharacterBody3D
class_name Actor

enum {IDLE, PATROL, STALLED}

@export var move_speed = 0.75

# State
var state = IDLE

# Navigation
@onready var nav_agent = $NavigationAgent3D
const navigation_cycle = 10
var current_navigation_delay = 0
var next_position
var follow_director
var level

func _physics_process(_delta: float) -> void:
	match state:
		IDLE:
			velocity = Vector3.ZERO
		PATROL:
			move()
			move_and_slide()
		STALLED:
			velocity = Vector3.ZERO

func move():
	current_navigation_delay += 1
	if not next_position:
		current_navigation_delay = navigation_cycle
	if current_navigation_delay == navigation_cycle:
		next_position = nav_agent.get_next_path_position()
		current_navigation_delay = 0
	velocity = lerp(velocity, (next_position - global_transform.origin).normalized() * move_speed, 0.05)
	velocity.y = 0
	if next_position != global_position:
		look_at(next_position)
		#if move_speed > WALK_SPEED:
			#anim.play("run")
		#else:
			#anim.play("walk")
	else:
		#anim.play("idle")
		pass
	rotation.x = 0
	rotation.z = 0

func patrol(target_position):
	state = PATROL
	nav_agent.set_target_position(target_position)


func _on_navigation_agent_3d_target_reached() -> void:
	follow_director._on_target_reached()
