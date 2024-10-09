extends Node

@onready var items : RandomItems = RandomItems.new()
var paused : bool = false

var tooltip_scene : PackedScene = preload("res://scenes/ui/tooltip.tscn")
var pause_scene : PackedScene
var _time_scale : float = 1.0
var score : float = 0
@onready var player : Player = get_tree().get_first_node_in_group("player")


const player_stats : Array[String] = [
	"speed",
	"jump_height",
	"damage",
	"damage_resist",
	"projectiles_max",
	"character_size",
	"attack_cooldown",
]

func get_player_stats() -> String:
	return str(player.player_stats)

func _input(event: InputEvent) -> void:
	if event.is_action_released("pause"):
		paused = not paused
		Engine.time_scale = _time_scale if not paused else 0.0
		var pause_menu  = get_tree().get_first_node_in_group("pause")
		pause_menu.visible = not pause_menu.visible
		
