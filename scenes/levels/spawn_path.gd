class_name Spawner extends Path2D

signal all_enemies_dead

@export var enemy_container : Node

@export var small_weight : float = 1000
@export var big_weight : float = 0
@onready var spawn_timer : Timer = $SpawnTimer

var enemies_alive : Array[Enemy]

const small_enemies = [
	preload("res://scenes/enemies/enemy_egg.tscn"),
]

const big_enemies = [
	preload("res://scenes/enemies/big_boy_enemy.tscn"),
]

@export var spawn_time : float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SpawnTimer.wait_time = spawn_time
	$SpawnTimer.timeout.connect(_on_spawn)
	#$SpawnTimer.start()

func start():
	_on_spawn()
	$SpawnTimer.start()

func _on_spawn():
	var decision : float = randi_range(0,small_weight+big_weight)
	var enemy : Enemy
	if decision <= big_weight:
		var rand_idx = randi_range(0,len(big_enemies)-1)
		enemy = big_enemies[rand_idx].instantiate()
	else:
		var rand_idx = randi_range(0,len(small_enemies)-1)
		enemy = small_enemies[rand_idx].instantiate()
	
	enemy.position = $PathFollow2D.position
	if enemy_container:
		enemy_container.add_child(enemy)
	else:
		add_child(enemy)
	
	$SpawnTimer.wait_time = spawn_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$PathFollow2D.progress_ratio+=delta

		#queue_free()
