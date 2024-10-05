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
@onready var health_component : HealthComponent = $HealthComponent
@onready var modifiers : Modifiers = $Modifiers

var can_jump: bool = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_count: int = 0
var last_movement_direction = Vector2.ZERO
var max_jump_count = 2
var number_colliding_bodies = 0
var temporary_inventory_array: Array[int] = []

var _current_direction = 0
var movement_disabled : bool = false


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
	if movement_disabled:
		interact()
		move_and_slide()
		return
	# Jump and double jump
	if Input.is_action_just_pressed("jump") and can_jump:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		can_jump = !jump_count >= max_jump_count
	
	# Left, right movement
	var direction = Vector2(Input.get_action_strength("run_right") - Input.get_action_strength("run_left"), 0.0)
	set_animation(direction)
	
	velocity.x = direction.x * MAX_SPEED
	velocity.x = clampf(velocity.x, -MAX_SPEED, MAX_SPEED)
	var slow_mod = modifiers.get_modifier("slow") as ModifierData
	var speed_mod = modifiers.get_modifier("speed") as ModifierData
	#print(slow_mod)
	if slow_mod:
		velocity.x *= slow_mod.value
	if speed_mod:
		velocity.x *= speed_mod.value
	
	_current_direction = 1.0 if velocity.x > 0.0 else -1.0 if velocity.x > 0.0 else 0.0
	interact()
	move_and_slide()


func set_animation(direction: Vector2):
	if direction == null:
		return
	
	if not direction.is_zero_approx():
		last_movement_direction = direction
		animation_mode.travel("run_right")
		#animation_tree.set("parameters/run/blend_position", direction)
	else:
		animation_mode.travel("idle")
	
	$Sprite2D.flip_h= (direction.x < 0)

# TODO – Expand the interact() function
# Enable the player to interact with game objects (i.e., item pick-up, doors, etc.)
# This is currently only set up with items
func interact():
	var items = get_tree().get_nodes_in_group("item")
	items = items.filter(func(item: Node2D):
		return item.global_position.distance_squared_to(global_position) < pow(INTERACTION_RANGE, 2)
	)
	
	if items.size() == 0:
		return
	
	items.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(global_position)
		var b_distance = b.global_position.distance_squared_to(global_position)
		return a_distance < b_distance
	)
	
	var item_closest_to_player = items[0] as RandomItem
	
	if Input.is_action_just_pressed("interact"):
		# HACK – Storing item_ids in an inventory array for now (may not even need this for the game jam)
		temporary_inventory_array.append(item_closest_to_player["item_id"])
		item_closest_to_player.queue_free()
		#TODO move to appropriate location
		modifiers.apply_modifier(item_closest_to_player.modifier)


func on_body_entered(_other_body: Node2D):
	number_colliding_bodies += 1


func on_body_exited(_other_body: Node2D):
	number_colliding_bodies -= 1


func on_coyote_timer_timeout():
	can_jump = false


func on_item_picked_up(item_name: String):
	# TODO – Do something upon item pick up
	pass



func _on_hurt_box_component_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	# FIXME – What are local_shape_index and body_shape_index used for?
	if is_instance_of(body,TileMapLayer):
		var tilemap : TileMapLayer = body as TileMapLayer
		var coords : Vector2i = tilemap.get_coords_for_body_rid(body_rid)
		var data = tilemap.get_cell_tile_data(coords).get_custom_data("effects")
		#print(data, "eeg")
		if "damage" in data:
			#print("Damaged for ", data['damage'])
			# HACK – Added an arbitrary "knockback" value here since the damage() method now requires it
			health_component.damage(10, 5)
		if "knockback" in data:
			#print("Knockback ")
			velocity.x += -_current_direction * data["knockback"]
			velocity.y -= data["knockback"]
			movement_disabled=true
			get_tree().create_timer(0.5).timeout.connect(
			func():
				movement_disabled=false
				)
		if "slow" in data:
			#print("apply slow")
			var mdat : ModifierData = data["slow"] as ModifierData
			modifiers.apply_modifier(mdat)
			


func _on_collision_area_2d_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if is_instance_of(body,TileMapLayer):
		var tilemap : TileMapLayer = body as TileMapLayer
		var coords : Vector2i = tilemap.get_coords_for_body_rid(body_rid)
		var data = tilemap.get_cell_tile_data(coords).get_custom_data("effects") # Replace with function body.
		if "slow" in data:
			modifiers.remove_modifier("slow")


func _on_collision_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if is_instance_of(body, TileMapLayer):
		var tilemap : TileMapLayer = body as TileMapLayer
		var coords : Vector2i = tilemap.get_coords_for_body_rid(body_rid)
		var data = tilemap.get_cell_tile_data(coords).get_custom_data("effects") # Replace with function body.
		if "slow" in data:
			#print("apply slow")
			var mdat : ModifierData = data["slow"] as ModifierData
			modifiers.apply_modifier(mdat)
