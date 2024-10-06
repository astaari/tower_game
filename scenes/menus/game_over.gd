extends CanvasLayer

@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var return_button: Button = %ReturnButton
@onready var quit_button: Button = %QuitButton

const main_menu_scene_path: String = "res://scenes/menus/main_menu.tscn"

func _ready() -> void:
	return_button.pressed.connect(_on_return_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)


func _on_return_button_pressed() -> void:
	# HACK – Resetting current_level to -2 so that we arrive at -1 after the signal emits
	EventManager.current_level = -2
	EventManager.emit_level_changed()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
