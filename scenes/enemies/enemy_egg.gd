extends Enemy

@onready var patrol_timer : Timer = $PatrolTimer
@export_range(1,4) var max_move_duration : float = 4
@export_range(1,2) var max_idle_duration : float = 2.0

var min_range = 200
var max_range = 400

var x_dir : float = -1
var active_projectiles : Array[Projectile] = []

var projectile : PackedScene = preload("res://scenes/enemies/egg_projectile.tscn")

var idling : bool = false
func _ready():
	super._ready()
	$DetectionBox/CollisionShape2D.shape.radius = float(max_range+min_range)/2.
	#print($DetectionBox/CollisionShape2D.shape.radius)
	$DetectionBox.player_in_range.connect(_to_attack_mode)
	$DetectionBox.player_out_of_range.connect(_exit_attack_mode)
	reset_patrol_timer()
	patrol_timer.timeout.connect(_on_patrol_timer_timeout)
	patrol_timer.start()
	
	
func reset_patrol_timer():
	if not idling:
		x_dir = -x_dir
		patrol_timer.wait_time = randf_range(0.6,max_move_duration)
	else:
		patrol_timer.wait_time = randf_range(0.6,max_idle_duration)
func _on_patrol_timer_timeout():
	if  current_state != EnemyState.PATROL:
		return
	idling = not idling
	
	reset_patrol_timer()


func _draw_enemy() -> void:
	if velocity.x != 0:
		$Sprite2D.flip_h = velocity.x > 0
		
	$Sprite2D.flip_h = ($Sprite2D.flip_h or 
		(current_target) and (global_position.direction_to(current_target.global_position).x > 0))
	if "attack" in $AnimationPlayer.current_animation:
		return
	if not idling:#velocity!= Vector2.ZERO:
		$AnimationPlayer.play("enemy_egg_animations/run")
	else:
		$AnimationPlayer.play("enemy_egg_animations/idle")

func do_attack():
	if target_direction.x < 0:
		$ProjSpawnPoint.scale.x = Vector2.RIGHT.x
	else:
		$ProjSpawnPoint.scale.x = Vector2.LEFT.x
	var proj = projectile.instantiate()
	proj.direction = target_direction
	proj.global_position = $ProjSpawnPoint.global_position
	Game.projectile_container.add_child(proj)
		



func _movement(_delta : float):
	var movement = Vector2.ZERO
	if current_state == EnemyState.PATROL:
		if not idling:
			
			movement = Vector2(SPEED,0)*x_dir
			#print(movement)
	elif current_state == EnemyState.IDLE:
		return Vector2.ZERO
	elif current_state == EnemyState.ATTACK:
		if $AnimationPlayer.is_playing() and "attack" in $AnimationPlayer.current_animation:
			pass
		elif current_target:
			var distance  = global_position.distance_to(current_target.global_position)
			target_direction = global_position.direction_to(current_target.global_position)
			if distance > min_range and distance < max_range:
				#print(distance)
				$AnimationPlayer.play("enemy_egg_animations/attack",-1,0.66)
			elif distance <=max_range:
				movement = Vector2(-target_direction.x,0)*SPEED
			else:
				movement = Vector2(target_direction.x,0)*SPEED
		
	movement.y = velocity.y
	#movement.y = ProjectSettings.get("physics/2d/default_gravity")*delta
	#print(current_target)
	return movement
	

func _to_attack_mode(target : Player):
	#pass
	current_target = target
	current_state=EnemyState.ATTACK


func _exit_attack_mode():
	print("EXITING")
	current_target=null
	current_state = EnemyState.PATROL


func _on_died() -> void:
	pass


func _on_hurt_box_component_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print(body, " YOU")
		


func _on_hurt_box_component_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		pass
