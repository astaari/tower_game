extends Node

const scene_path_prefix: String = "res://scenes/levels/level-"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var current_scene = $MainMenu

const main_menu_scene_path: String = "res://scenes/menus/main_menu.tscn"
const end_game_scene_path: String = "res://scenes/menus/game_over.tscn"

@onready var player : Player = $Player


func _ready() -> void:
	EventManager.level_changed.connect(_on_level_changed)
	Game.player=player


func get_next_level_scene_path() -> String:
	print(EventManager.current_level)
	if EventManager.current_level == -1:
		return main_menu_scene_path
	var scene_path = str(scene_path_prefix, EventManager.current_level, ".tscn")
	print(scene_path)
	if not FileAccess.file_exists(scene_path):
		print("o?")
		pass
	return scene_path if FileAccess.file_exists(scene_path) else end_game_scene_path


func _on_level_changed():
	Game.block_pause()
	#player.reparent(self)
	var next_scene_path = get_next_level_scene_path()
	var next_scene = load(next_scene_path).instantiate()
	animation_player.play("fade_out")
	await animation_player.animation_finished
	if EventManager.current_level>=0:
		$GameUi.visible=true
		#$GameCamera.visible=true
	add_child(next_scene)
	#player.reparent(next_scene)
	
	current_scene.queue_free()
	current_scene = next_scene
	animation_player.play("fade_in")
	await animation_player.animation_finished
	if Game.player:
		Game.player.visible = true
    Game.player.z_index=9
		Game.player.animation_player.stop()
	
		Game.player.animation_player.play_backwards("into_the_portal")
		await Game.player.animation_player.animation_finished
		Game.player.animation_player.queue("RESET")
		Game.player.movement_disabled=false

	Game.unblock_pause()
