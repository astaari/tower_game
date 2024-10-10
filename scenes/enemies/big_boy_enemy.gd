extends Enemy


@onready var patrol_timer :Timer = $Timer
var x_dir = 1

func _ready() -> void:
	super._ready()
	$DetectionBox.player_in_range.connect(_to_attack_mode)
	$DetectionBox.player_out_of_range.connect(_exit_attack_mode)
	SPEED = 100*Game.difficulty_mult
	reset_patrol_timer()
	patrol_timer.timeout.connect(_on_patrol_timer_timeout)
	patrol_timer.start()
	
func reset_patrol_timer():
	x_dir = -x_dir
	patrol_timer.wait_time = randf_range(0.2,3)
func _on_patrol_timer_timeout():
	if  current_state != EnemyState.PATROL:
		return
	
	reset_patrol_timer()

func _draw_enemy():
	if x_dir >=0:
		$AnimationPlayer.play("big_boy_enemy/hover_right")
	elif x_dir < 0:
		$AnimationPlayer.play("big_boy_enemy/hover_left")

func _movement(delta : float) -> Vector2:
	var movement : Vector2 = Vector2.ZERO
	
	if current_state == EnemyState.ATTACK:
		if current_target:
			target_direction = global_position.direction_to(current_target.global_position)
			movement.x = target_direction.x*SPEED
	
		
	
	movement.y = velocity.y
	#print(velocity)
	return movement



func _to_attack_mode(target : Player):
	#pass
	print("in range")
	current_target = target
	current_state=EnemyState.ATTACK
	
func _exit_attack_mode():
	print("EXITING")
	
	current_target=null
	current_state = EnemyState.PATROL


func _on_detection_box_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_detection_box_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
