extends Node

@onready var items : RandomItems = RandomItems.new()
var paused : bool = false

var tooltip_scene : PackedScene = preload("res://scenes/ui/tooltip.tscn")
var pause_scene : PackedScene
var _time_scale : float = 1.0


const player_stats : Array[String] = [
	"speed",
	"jump_height",
	"damage",
	"projectiles_max",
	"character_size",
	"attack_cooldown",
]


func _input(event: InputEvent) -> void:
	if event.is_action_released("pause"):
		paused = not paused
		Engine.time_scale = _time_scale if not paused else 0.0
