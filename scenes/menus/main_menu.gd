extends CanvasLayer

@export var title: String
@export var description: String

@onready var animation_player: AnimationPlayer = $AnimationPlayer

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


func _ready() -> void:
	set_label_text()
	start_button.pressed.connect(_on_start_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	
	effects_slider.value_changed.connect(_on_effects_slider_changed)
	music_slider.value_changed.connect(_on_music_slider_changed)
	menu_sounds_slider.value_changed.connect(_on_menu_sounds_slider_changed)
	master_slider.value_changed.connect(_on_master_slider_changed)
	
	settings_back_button.pressed.connect(_on_back_button_pressed)



func update_audio_bus(audio_bus_name: String, value: float) -> void:
	var audio_bus_index: int = AudioServer.get_bus_index(audio_bus_name)
	
	if audio_bus_index == -1:
		print("Audio Bus Not Found: " + audio_bus_name)
		return
	
	AudioServer.set_bus_volume_db(audio_bus_index, linear_to_db(value))


func set_label_text() -> void:
	title_label.text = title
	description_label.text = description


func _toggle_menu_containers(menu_name: String) -> void:
	match menu_name:
		"title":
			%TitleContainer.visible = true
			%SettingsContainer.visible = false
		"settings":
			%TitleContainer.visible = false
			%SettingsContainer.visible = true
		_:
			return


func _on_back_button_pressed() -> void:
	_toggle_menu_containers("title")


func _on_effects_slider_changed(value: float) -> void:
	update_audio_bus("Effects", value)


func _on_master_slider_changed(value: float) -> void:
	update_audio_bus("Master", value)


func _on_menu_sounds_slider_changed(value: float) -> void:
	update_audio_bus("Menu", value)


func _on_music_slider_changed(value: float) -> void:
	update_audio_bus("Music", value)


func _on_start_button_pressed() -> void:
	animation_player.play("start")
	EventManager.emit_level_changed()


func _on_settings_button_pressed() -> void:
	_toggle_menu_containers("settings")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
