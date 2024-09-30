extends CharacterBody2D

const MAX_SPEED = 200
const ACCELERATION_SMOOTHING = 50

@onready var animation_tree = $AnimationTree
@onready var animation_mode = animation_tree.get("parameters/playback")
@onready var collision_area = $CollisionArea2D

var last_movement_direction = Vector2.ZERO
var number_colliding_bodies = 0


func _ready():
	animation_tree.active = true
	collision_area.body_entered.connect(on_body_entered)
	collision_area.body_exited.connect(on_body_exited)


func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	var target_velocity = direction * MAX_SPEED
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	move_and_slide()
	set_animation(direction)


func get_movement_vector():
	var x_movement = Input.get_action_strength("run_right") - Input.get_action_strength("run_left")
	var y_movement = Input.get_action_strength("run_down") - Input.get_action_strength("run_up")
	return Vector2(x_movement, y_movement)


func set_animation(direction: Vector2):
	if direction == null:
		return
	
	if not direction.is_zero_approx():
		last_movement_direction = direction
		animation_mode.travel("run")
		animation_tree.set("parameters/run/blend_position", direction)
	else:
		animation_mode.travel("idle")
		animation_tree.set("parameters/idle/blend_position", last_movement_direction)


func on_body_entered(_other_body: Node2D):
	number_colliding_bodies += 1


func on_body_exited(_other_body: Node2D):
	number_colliding_bodies -= 1
