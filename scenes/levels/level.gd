extends Node
class_name Level

const scene_path_prefix: String = "res://scenes/levels/level-"

@onready var color_swap_canvas_layer: CanvasLayer = $ColorSwapCanvasLayer


@export_range(0, 9) var level: int = 0
@export_color_no_alpha var new_black: Color
@export_color_no_alpha var new_white: Color

var next_level: int
var is_last_level: bool = false

var next_level_scene_path: String


func _ready() -> void:
	set_shader_parameters()
	next_level_scene_path = get_next_level_scene_path()
	EventManager.level_changed.connect(on_level_changed)


func set_shader_parameters() -> void:
	var color_shader_rect = color_swap_canvas_layer.get_child(0) as ColorRect
	if color_shader_rect == null:
		return
	
	if new_black == null and new_white == null:
		return

	color_shader_rect.material.set("shader_parameter/new_black", new_black)
	color_shader_rect.material.set("shader_parameter/new_white", new_white)


func get_next_level_scene_path() -> String:
	var scene_path = str(scene_path_prefix, level + 1, ".tscn")
	return scene_path if FileAccess.file_exists(scene_path) else ""


func on_level_changed() -> void:
	if next_level_scene_path == "":
		# TODO – Add credits or some shiz
		print("End of game!")
	else:
		get_tree().change_scene_to_file(next_level_scene_path)
		# HACK – Add better transition to next level scene
