extends CanvasLayer

@export var title: String
@export var description: String

@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var start_button: Button = %StartButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton

@onready var effects_slider: HSlider = %EffectsSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var menu_sounds_slider: HSlider = %MenuSoundsSlider
@onready var master_slider: HSlider = %MasterSlider
@onready var settings_back_button: Button = %SettingsBackButton

@onready var effects_audio_bus_name = "Effects"
@onready var master_audio_bus_name = "Master"
@onready var menu_audio_bus_name = "Menu"
@onready var music_audio_bus_name = "Music"

@onready var first_level: PackedScene = preload("res://scenes/levels/level-0.tscn")
@onready var color_swap_shader_material: ShaderMaterial = preload("res://assets/shaders/color_swap_shader_material.tres")

@onready var menu_containers: Dictionary = {
	"title": %TitleContainer,
	"settings": %SettingsContainer
}


func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	
	effects_slider.value_changed.connect(_on_effects_slider_changed)
	music_slider.value_changed.connect(_on_music_slider_changed)
	menu_sounds_slider.value_changed.connect(_on_menu_sounds_slider_changed)
	master_slider.value_changed.connect(_on_master_slider_changed)
	
	settings_back_button.pressed.connect(_on_back_button_pressed)

	title_label.text = title
	description_label.text = description


func update_audio_bus(audio_bus_name: String, value: float) -> void:
	var audio_bus_index: int = AudioServer.get_bus_index(audio_bus_name)
	
	if audio_bus_index == -1:
		print("Audio Bus Not Found: " + audio_bus_name)
		return
	
	AudioServer.set_bus_volume_db(audio_bus_index, linear_to_db(value))


func _toggle_menu_containers(menu_name: String) -> void:
	for key in menu_containers:
		var menu_container = menu_containers[key]
		menu_container.visible = key == menu_name


func _on_back_button_pressed() -> void:
	_toggle_menu_containers("title")


func _on_effects_slider_changed(value: float) -> void:
	update_audio_bus(effects_audio_bus_name, value)


func _on_master_slider_changed(value: float) -> void:
	update_audio_bus(master_audio_bus_name, value)


func _on_menu_sounds_slider_changed(value: float) -> void:
	update_audio_bus(menu_audio_bus_name, value)


func _on_music_slider_changed(value: float) -> void:
	update_audio_bus(music_audio_bus_name, value)


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(first_level)


func _on_settings_button_pressed() -> void:
	_toggle_menu_containers("settings")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
