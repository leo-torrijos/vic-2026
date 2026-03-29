extends CharacterBody3D
class_name Actor

enum {FREEZE, IDLE, PATROL, DIE, STALLED, WALK_TO_PILLS, TAKE_PILLS, DIE_TO_PILLS}

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
var nav_mesh

func _physics_process(_delta: float) -> void:
	if state != FREEZE and not is_on_floor():
		velocity.y -= 9
	match state:
		FREEZE:
			velocity = Vector3.ZERO
		IDLE:
			
			velocity = Vector3.ZERO
		PATROL:
			move()
			move_and_slide()
		STALLED:
			velocity = Vector3.ZERO

func move():
	if not is_on_floor():
		return
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
	if state != TAKE_PILLS and state != WALK_TO_PILLS:
		state = PATROL
		nav_agent.set_target_position(target_position)


func _on_navigation_agent_3d_target_reached() -> void:
	if follow_director:
		follow_director._on_target_reached()
