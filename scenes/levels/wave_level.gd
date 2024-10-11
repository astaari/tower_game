extends Level
signal on_level_finished

@onready var enemy_spawner : Spawner =  $EnemySpawner
#TODO change this back to a normal time
#TODO Scale spawn rate maybe?
@export var wave_length : float = 20
@onready var items : Path2D = $Items/ItemPath
@onready var items_follow : PathFollow2D = $Items/ItemPath/Follow
@onready var break_timer : Timer = $BreakTimer
@onready var wave_timer : Timer = $WaveTimer

@onready var wave_ui :WaveUi= $wave_ui

var wave_number : int = 1
var _base_item_drop_count = 3
var _elapsed : float = 0
var break_time : float = 10
var wave_running : bool = false
var time_left : float = 20

var done_spawning : bool = false
var current_scene_timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	Game.score=0
	if Game.player:
		Game.player.visible=true
	wave_ui.wavenum_label.text = "Wave: %d" % wave_number
	
	break_timer.wait_time = break_time
	break_timer.timeout.connect(_break_over)
	break_timer.start()
	wave_timer.timeout.connect(_level_timer_timeout)
	#enemy_spawner.spawn_timer.timeout.connect(func():done_spawning=true)
	if enemy_spawner:
		enemy_spawner.all_enemies_dead.connect(_on_all_enemies_dead)

func _break_over() -> void:
	wave_timer.wait_time=wave_length
	wave_running=true
	done_spawning=false
	enemy_spawner.start()
	wave_timer.start()
	
func _level_timer_timeout():
	if enemy_spawner:
		enemy_spawner.spawn_timer.stop()
		done_spawning = true
	
func _process(delta : float):
	
	if wave_running:

		wave_ui.wavetime_label.text = wave_ui.during_text %  wave_timer.time_left
	else:
		wave_ui.wavetime_label.text = wave_ui.wait_text % int(break_timer.time_left)
		
		

	if wave_running and done_spawning and enemy_spawner.enemy_container.get_child_count()==0:
		wave_running=false
		enemy_spawner.all_enemies_dead.emit()
	
	
func _on_all_enemies_dead():
	_drop_items()
	#wave_running=false
	wave_number+=1
	wave_ui.wavenum_label.text = "Wave: %d" % wave_number
	if wave_number%5 == 0:
		enemy_spawner.big_weight+=50
		break_time+=3
		break_timer.wait_time=break_time
	if wave_number%2 == 0:
		enemy_spawner.spawn_time-=0.1
		wave_length+=5
	Game.incremenent_difficulty()
	break_timer.start()
	time_left = wave_length
	
func _drop_items():
	var count : int = floor((Game.difficulty_mult-1)/0.25+_base_item_drop_count)
	#var step = 1/(count-1)
	for i in range(count):
		var item : RandomItem = random_item_scene.instantiate()
		item.position = items_follow.position
		items_follow.progress+=64
		items.add_child(item)
		
