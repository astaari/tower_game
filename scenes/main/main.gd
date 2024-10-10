extends Node

const scene_path_prefix: String = "res://scenes/levels/level-"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var current_scene = $MainMenu

const main_menu_scene_path: String = "res://scenes/menus/main_menu.tscn"
const end_game_scene_path: String = "res://scenes/menus/game_over.tscn"


func _ready() -> void:
	EventManager.level_changed.connect(_on_level_changed)


func get_next_level_scene_path() -> String:
	if EventManager.current_level == -1:
		return main_menu_scene_path
	var scene_path = str(scene_path_prefix, EventManager.current_level, ".tscn")
	if not FileAccess.file_exists(scene_path):
		pass
	return scene_path if FileAccess.file_exists(scene_path) else end_game_scene_path


func _on_level_changed():
	var next_scene_path = get_next_level_scene_path()
	var next_scene = load(next_scene_path).instantiate()
	animation_player.play("fade_out")
	await animation_player.animation_finished
	add_child(next_scene)
	current_scene.queue_free()
	current_scene = next_scene
	animation_player.play("fade_in")
