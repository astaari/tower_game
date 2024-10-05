extends Enemy
@onready var patrol_timer : Timer = $PatrolTimer
@export_range(1,4) var max_move_duration : float = 4
@export_range(1,2) var max_idle_duration : float = 2.0
var _rng = RandomNumberGenerator.new()

var idling : bool = false
func _ready():
	#super._ready()
	reset_patrol_timer()
	patrol_timer.timeout.connect(_on_patrol_timer_timeout)
	patrol_timer.start()
	
func reset_patrol_timer():
	#patrol_timer.time_left = 0
	if not idling:
		patrol_timer.wait_time = _rng.randf_range(0.6,max_move_duration)
	else:
		patrol_timer.wait_time = _rng.randf_range(0.6,max_idle_duration)
func _on_patrol_timer_timeout():
	if  current_state != EnemyState.PATROL:
		return
	idling = not idling
	if not idling:
		$Sprite2D.flip_h = not $Sprite2D.flip_h
	reset_patrol_timer()



func _patrol(delta : float) -> Vector2:
	if idling:
		$AnimationPlayer.play("enemy_egg_animations/idle")
		return Vector2(0,0)
	$AnimationPlayer.play("enemy_egg_animations/run")
	return Vector2(-100,0) if not $Sprite2D.flip_h else Vector2(100,0)


func _on_hurt_box_component_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print(body)


func _on_hurt_box_component_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
