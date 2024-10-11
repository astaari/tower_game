extends Node

const scene_path_prefix: String = "res://scenes/levels/level-"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var current_scene = $MainMenu

const main_menu_scene_path: String = "res://scenes/menus/main_menu.tscn"
const end_game_scene_path: String = "res://scenes/menus/game_over.tscn"

const levels = [
	preload("res://scenes/levels/level-0.tscn"),
	preload("res://scenes/levels/level-1.tscn"),
	preload("res://scenes/levels/level-2.tscn"),
	preload("res://scenes/levels/level-3.tscn"),
	preload("res://scenes/levels/level-4.tscn"),
]

const arcade_level = preload("res://scenes/levels/level-100.tscn")
const game_over = preload("res://scenes/menus/game_over.tscn")
const main_menu = preload("res://scenes/menus/main_menu.tscn")

@onready var player : Player = $Player


func _ready() -> void:
	EventManager.level_changed.connect(_on_level_changed)
	Game.player=player


func get_next_level_scene() -> PackedScene:
	print(EventManager.current_level)
	if EventManager.current_level == -1:
		return main_menu
	if EventManager.current_level<-1:
		return game_over
	if EventManager.current_level >= len(levels):
		if $GameUi:
			$GameUi.show_score_panel()
		return arcade_level
	if $GameUi:
		$GameUi.hide_score_panel()
	#var scene_path = str(scene_path_prefix, EventManager.current_level, ".tscn")
	#print(scene_path)
	return levels[EventManager.current_level]


func _on_level_changed():
	Game.block_pause()
	#player.reparent(self)
	var next_scene = get_next_level_scene().instantiate()
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
	
		#Game.player.animation_player.play_backwards("into_the_portal")
		#await Game.player.animation_player.animation_finished
		Game.player.animation_player.queue("RESET")
		Game.player.movement_disabled=false

	Game.unblock_pause()
