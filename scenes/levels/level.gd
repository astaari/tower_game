extends Node
class_name Level



@onready var color_swap_canvas_layer: CanvasLayer = $ColorSwapCanvasLayer
const random_item_scene : PackedScene = preload("res://scenes/items/random_item.tscn")
@export_range(0, 9) var level: int = 0
@export_color_no_alpha var dark_color
@export_color_no_alpha var light_color
@onready var player_spawn_point : Node2D = $PlayerSpawnPoint

func _ready() -> void:
	
	Game.player.global_position = player_spawn_point.global_position
	print(Game.player.global_position)
	set_shader_parameters()
	#$LevelGate.visible=false
	


func set_shader_parameters() -> void:
	var color_shader_rect = color_swap_canvas_layer.get_child(0) as ColorRect
	if color_shader_rect == null:
		return
	
	if dark_color == null or light_color == null:
		return
	
	color_shader_rect.material.set("shader_parameter/new_black", dark_color)
	color_shader_rect.material.set("shader_parameter/new_white", light_color)
