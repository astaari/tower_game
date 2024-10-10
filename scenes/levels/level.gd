extends Node
class_name Level

signal on_level_finished

@onready var color_swap_canvas_layer: CanvasLayer = $ColorSwapCanvasLayer

const random_item_scene : PackedScene = preload("res://scenes/items/random_item.tscn")
@export_range(0, 9) var level: int = 0
@export_color_no_alpha var dark_color
@export_color_no_alpha var light_color

@onready var enemy_spawner : Spawner =  $Path2D
#TODO change this back to a normal time
#TODO Scale spawn rate maybe?
@export var level_length : float = 10


var _base_item_drop_count = 3
var _elapsed : float = 0

func _ready() -> void:
	set_shader_parameters()
	$LevelGate.visible=false
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

func set_shader_parameters() -> void:
	var color_shader_rect = color_swap_canvas_layer.get_child(0) as ColorRect
	if color_shader_rect == null:
		return
	
	if dark_color == null or light_color == null:
		return
	
	color_shader_rect.material.set("shader_parameter/new_black", dark_color)
	color_shader_rect.material.set("shader_parameter/new_white", light_color)
