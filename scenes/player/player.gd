extends CharacterBody2D

const MAX_SPEED = 200
const ACCELERATION_SMOOTHING = 10
const JUMP_VELOCITY = -350.0
const DOUBLE_JUMP_VELOCITY = -700.0
const DASH_VELOCITY = MAX_SPEED * 2.5
const INTERACTION_RANGE = 150

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_mode = animation_tree.get("parameters/playback")
@onready var collision_area: Area2D = $CollisionArea2D
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var hurt_box_component: HurtBoxComponent = $HurtBoxComponent
@onready var hurt_box_collision_shape: CollisionShape2D = $HurtBoxComponent/CollisionShape2D

var can_jump: bool = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_count: int = 0
var last_movement_direction = Vector2.ZERO
var max_jump_count = 2
var number_colliding_bodies = 0
var temporary_inventory_array: Array[Object] = []


func _ready():
	animation_tree.active = true
	collision_area.body_entered.connect(on_body_entered)
	collision_area.body_exited.connect(on_body_exited)
	coyote_timer.timeout.connect(on_coyote_timer_timeout)
	EventManager.item_picked_up.connect(on_item_picked_up)


func _physics_process(delta: float) -> void:
	# Reset jump flags when on the floor, else apply gravity
	if is_on_floor():
		can_jump = true
		jump_count = 0
	else:
		coyote_timer.start()
		velocity.y += gravity * delta
	
	# Jump and double jump
	if Input.is_action_just_pressed("jump") and can_jump:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		can_jump = !jump_count >= max_jump_count
	
	# Left, right movement
	var direction = Vector2(Input.get_action_strength("run_right") - Input.get_action_strength("run_left"), 0.0)
	set_animation(direction)
	if abs(velocity.x) <= MAX_SPEED:
		velocity.x = direction.x * MAX_SPEED
	
	interact()
	move_and_slide()


func set_animation(direction: Vector2):
	if direction == null:
		return
	
	if not direction.is_zero_approx():
		last_movement_direction = direction
		animation_mode.travel("run")
		animation_tree.set("parameters/run/blend_position", direction)
	else:
		animation_mode.travel("idle")


# Enable the player to interact with game objects (i.e., item pick-up, doors, etc.)
# This is currently only set up with items
func interact():
	var items = get_tree().get_nodes_in_group("item")
	items = items.filter(func(item: Node2D):
		return item.global_position.distance_squared_to(global_position) < pow(INTERACTION_RANGE, 2)
	)
	
	if items.size() == 0:
		print("No item nodes retrieved from SceneTree")
		return
	
	items.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(global_position)
		var b_distance = b.global_position.distance_squared_to(global_position)
		return a_distance < b_distance
	)
	
	var item_closest_to_player = items[0] as Node2D
	print("Closest Item: ", item_closest_to_player["name"])
	
	if Input.is_action_just_pressed("interact"):
		print("Interaction input just pressed")
		temporary_inventory_array.append(item_closest_to_player)
		item_closest_to_player.queue_free()
		print("Player Inventory Array: ", temporary_inventory_array)


func on_body_entered(_other_body: Node2D):
	number_colliding_bodies += 1


func on_body_exited(_other_body: Node2D):
	number_colliding_bodies -= 1


func on_coyote_timer_timeout():
	can_jump = false


func on_item_picked_up(item_name: String):
	# Do a thing with this item
	print(item_name)
