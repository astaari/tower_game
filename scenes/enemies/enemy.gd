class_name Enemy extends CharacterBody2D
enum EnemyState{PATROL,IDLE,PREPARE,ATTACK}

@export var  current_state : EnemyState = EnemyState.PATROL

var current_target : CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _patrol(delta:float) -> Vector2:
	return Vector2.ZERO

func _prepare(delta) -> Vector2:
	return Vector2.ZERO
	
func _attack(delta:float,target :CharacterBody2D) -> Vector2:
	return Vector2.ZERO


func _physics_process(delta: float) -> void:
	var movement : Vector2 = Vector2.ZERO
	if current_state == EnemyState.PATROL:
		movement = _patrol(delta)
	elif current_state == EnemyState.PREPARE:
		movement = _prepare(delta)
	elif current_state == EnemyState.ATTACK:
		movement = _attack(delta,current_target)
		
	velocity=movement
	velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity")
	move_and_collide(Vector2(velocity.x,0)*delta)
