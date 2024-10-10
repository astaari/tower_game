extends Node

@onready var items : RandomItems = RandomItems.new()
var paused : bool = false

const _tooltip_scene : PackedScene = preload("res://scenes/ui/tooltip.tscn")
var current_tooltip : Tooltip
var pause_scene : PackedScene
var _time_scale : float = 1.0
var score : float = 0
@onready var player : Player = get_tree().get_first_node_in_group("player")

var health_mult : float = 1.0
var damage_mult : float = 1.0
var difficulty_mult : float = 1.0

var _block_pause : bool = false

func block_pause():
	_block_pause=true
func unblock_pause():
	_block_pause = false
	
func _ready() -> void:
	current_tooltip = _tooltip_scene.instantiate()
	current_tooltip.global_position = Vector2.ZERO
	current_tooltip.visible = false
	add_child(current_tooltip)


func show_tooltip(item : RandomItem):
	current_tooltip.item=item.item
	current_tooltip.global_position = item.global_position+Vector2.UP*300
	current_tooltip.visible=true


func tooltip_is_visible() -> bool:
	return current_tooltip.visible


func hide_tooltip():
	current_tooltip.visible=false
	current_tooltip.item=null

func incremenent_difficulty():
	health_mult+=0.1
	damage_mult+=0.05
	difficulty_mult+=0.075

const player_stats : Array[String] = [
	"speed",
	"jump_height",
	"damage",
	"damage_resist",
	#"projectiles_max",
	"character_size",
	"attack_speed",
]

func get_player_stats() -> String:
	if not player:
		player = get_tree().get_first_node_in_group("player")
	if player:
		return str(player.player_stats)
		
	return "Unavailable"


func pause():
	paused = not paused
	Engine.time_scale = _time_scale if not paused else 0.0
	var pause_menu  = get_tree().get_first_node_in_group("pause")
	if pause_menu:
		pause_menu.visible = not pause_menu.visible

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not _block_pause:
		pause()
		
