class_name Enemy extends CharacterBody2D
enum EnemyState{PATROL,IDLE,PREPARE,ATTACK}

@export var  current_state : EnemyState = EnemyState.PATROL
@export var score : float = 100

var current_target : CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

func _exit_tree() -> void:
	if $HealthComponent.current_health <= 0:
		Game.score+=score
		
func _draw_enemy():
	pass

func _movement(delta : float) -> Vector2:
	return Vector2.ZERO

func _physics_process(delta: float) -> void:
	
	#if current_state == EnemyState.PATROL:
		#movement = _patrol(delta)
	#elif current_state == EnemyState.PREPARE:
		#movement = _prepare(delta)
	#elif current_state == EnemyState.ATTACK:
		#movement = _attack(delta,current_target)
	var movement = _movement(delta)
	
	#print(velocity)
	if is_on_wall() and is_on_floor():
		movement.y = JUMP_VELOCITY
		#velocity.x = 0
		#velocity.x /= 2
		#print(velocity, " before")
		
	velocity = movement
	#velocity=movement if movement.y != 0 else Vector2(movement.x,velocity.y)
	velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity")*delta
	
	#print(velocity," after")
	_draw_enemy()
	
	move_and_slide()
