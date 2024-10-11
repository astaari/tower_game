class_name Player extends CharacterBody2D

const MAX_SPEED = 1000
const ACCELERATION_SMOOTHING = 10
const JUMP_VELOCITY = -350.0
const DOUBLE_JUMP_VELOCITY = -700.0
const DASH_VELOCITY = MAX_SPEED * 2.5
const INTERACTION_RANGE = 100

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_area: Area2D = $CollisionArea2D
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var hurt_box_component: HurtBoxComponent = $HurtBoxComponent
@onready var hurt_box_collision_shape: CollisionShape2D = $HurtBoxComponent/CollisionShape2D
@onready var health_component : HealthComponent = $HealthComponent
@onready var initial_pos = global_position
@onready var effects : Effects = $Effects
@onready var modifiers : Modifier

@export var player_stats : PlayerStats = PlayerStats.new()


var can_jump: bool = true
var can_attack : bool = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_count: int = 0
var last_movement_direction = Vector2.ZERO
var max_jump_count = 2
var number_colliding_bodies = 0
var projectile_scene : PackedScene = preload("res://scenes/player/player_projectile.tscn")
var projectiles_active: int = 0
var projectiles_max: int = 2
var tooltip : Panel

var _current_direction = 0
var movement_disabled : bool = false


func _attack_timer_timeout():
	can_attack = true

func _ready():
	EventManager.level_changed.connect(on_level_changed)
	player_stats.register(self)
	coyote_timer.timeout.connect(on_coyote_timer_timeout)
	$AttackTimer.timeout.connect(_attack_timer_timeout)
	$AttackTimer.wait_time = player_stats.attack_speed
	health_component.max_health = player_stats.max_health
	health_component.died.connect(func():
		#EventManager.to_main_menu()
		EventManager.current_level=-3
		EventManager.emit_level_changed()
		)
	print(str(player_stats))


func _exit_tree() -> void:
	player_stats.unregister()


func _process(_delta: float) -> void:
	$HurtBoxComponent.visible = health_component.damage_immune


func _physics_process(delta: float) -> void:
	if Game.paused:
		return
	# Reset jump flags when on the floor, else apply gravity
	if is_on_floor():
		can_jump = true
		jump_count = 0
	else:
		coyote_timer.start()
		velocity.y += gravity*delta
	if movement_disabled:
		interact()
		move_and_slide()
		return
	# Jump and double jump
	if Input.is_action_just_pressed("jump") and can_jump:
		var jump_velocity = player_stats.jump_height_to_speed()
		velocity.y = jump_velocity
		#print(jump_velocity)
		jump_count += 1
		can_jump = !jump_count >= max_jump_count
	if Input.is_action_pressed("down") and not is_on_floor():
		velocity.y += 25
	
	# Left, right movement
	var direction = Vector2(Input.get_action_strength("run_right") - Input.get_action_strength("run_left"), 0.0)
	set_animation(direction)
	
	if Input.is_action_pressed("attack") and projectiles_active < projectiles_max:
		attack(last_movement_direction)
	
	velocity.x = direction.x * player_stats.speed
	velocity.x = clampf(velocity.x, -MAX_SPEED, MAX_SPEED)

	
	_current_direction = 1.0 if velocity.x > 0.0 else -1.0 if velocity.x > 0.0 else 0.0
	#print("initial vs now : " , initial_pos, "  " , global_position)
	#print("Y-diff ", initial_pos.y-global_position.y)
	interact()
	move_and_slide()


func attack(direction: Vector2):
	print(projectiles_active)
	if not can_attack:
		return
	var projectile = projectile_scene.instantiate() as RigidBody2D
	projectile.linear_velocity.x = projectile.linear_velocity.x * direction.x
	var spawn_position = $ProjectilePos.global_position
	projectile.global_position = spawn_position
	
	projectiles_active = min(projectiles_active + 1, player_stats.projectiles_max)
	projectile.damage = player_stats.damage
	
	get_tree().root.add_child(projectile)
	can_attack = false
	$AttackTimer.start()


func set_animation(direction: Vector2):
	if direction == null:
		return
	
	$Sprite2D.flip_h= (direction.x < 0)
	if not direction.is_zero_approx():
		last_movement_direction = direction
		animation_player.play("run_right")
	else:
		animation_player.play("idle")


func interact():
	var items = get_tree().get_nodes_in_group("item")
	items = items.filter(func(item: Node2D):
		return item.global_position.distance_squared_to(global_position) < pow(INTERACTION_RANGE, 2)
	)
	
	if items.size() == 0:
		Game.hide_tooltip()
		return
	
	items.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(global_position)
		var b_distance = b.global_position.distance_squared_to(global_position)
		return a_distance < b_distance
	)
	
	var item_closest_to_player = items[0] as RandomItem

	if item_closest_to_player.item!=Game.current_tooltip.item:
		Game.show_tooltip(item_closest_to_player)
		
	
	if Input.is_action_just_pressed("interact"):
		item_closest_to_player.queue_free()
		for modifier in item_closest_to_player.modifiers:
			player_stats.apply_modifier(modifier)
		Game.hide_tooltip()
	elif Input.is_action_just_pressed("discard"):
		item_closest_to_player.queue_free()
		Game.hide_tooltip()
		#effects.apply_effect(item_closest_to_player.modifier)


func on_coyote_timer_timeout():
	can_jump = false


func _on_hurt_box_component_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
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
			movement_disabled = true
			get_tree().create_timer(0.5).timeout.connect(
			func():
				movement_disabled = false
				)
		if "slow" in data:
			#print("apply slow")
			print(typeof(data["slow"]), " type")
			var mdat : Effect = data["slow"] as Effect
			effects.apply_effect(mdat)

func on_level_changed() -> void:
	velocity = Vector2.ZERO
	movement_disabled = true
	animation_player.play("into_the_portal")
	await animation_player.animation_finished
	visible = false
	animation_player.queue("RESET")
	animation_player.play_backwards("into_the_portal")

	
	#animation_player.play_backwards("into_the_portal")
	#animation_player.stop()
