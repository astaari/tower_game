extends Level
signal on_level_finished

@onready var enemy_spawner : Spawner =  $EnemySpawner
#TODO change this back to a normal time
#TODO Scale spawn rate maybe?
@export var level_length : float = 10


var _base_item_drop_count = 3
var _elapsed : float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	get_tree().create_timer(level_length).timeout.connect(_level_timer_timeout)
	if enemy_spawner:
		enemy_spawner.all_enemies_dead.connect(_on_all_enemies_dead)

	
func _level_timer_timeout():
	if enemy_spawner:
		enemy_spawner.spawn_timer.stop()
	
func _process(delta : float):
	_elapsed+=delta
	
func _on_all_enemies_dead():
	print("Success!")
	$LevelGate.visible=true
	Game.difficulty_mult=4
	_drop_items()
	
func _drop_items():
	var count : int = floor((Game.difficulty_mult-1)/0.25+_base_item_drop_count)
	var step = 1/(count-1)
	for i in range(count):
		var item : RandomItem = random_item_scene.instantiate()
		item.position = $Items/Follow.position
		$Items/Follow.progress+=64
		$Items.add_child(item)
		
		
	#RandomItems
	pass
