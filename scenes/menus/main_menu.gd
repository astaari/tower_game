extends CanvasLayer

@export var title: String
@export var description: String

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var start_button: Button = %StartButton
@onready var arcade_button : Button = %ArcadeButton
@onready var howto_button : Button = %HowtoButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton

@onready var settings_container : Settings = %SettingsContainer



func _ready() -> void:
	set_label_text()
	if Game.player:
		Game.player.health_component.heal(1000000000000)

	start_button.pressed.connect(_on_start_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	arcade_button.pressed.connect(_on_arcade_button_pressed)
	howto_button.pressed.connect(_on_howto_button_pressed)
	
	
	settings_container.settings_back_button.visible=true
	settings_container.settings_back_button.pressed.connect(_on_back_button_pressed)

func _on_arcade_button_pressed():
	if animation_player.is_playing():
		return
	EventManager.current_level=99
	EventManager.emit_level_changed()
	print("OOO")
	
func _on_howto_button_pressed():
	if animation_player.is_playing():
		return
	%Howtoplay.visible=true

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





func _on_start_button_pressed() -> void:
	if animation_player.is_playing():
		return
	animation_player.play("start")
	EventManager.emit_level_changed()


func _on_settings_button_pressed() -> void:
	if animation_player.is_playing():
		return
	_toggle_menu_containers("settings")


func _on_quit_button_pressed() -> void:
	if animation_player.is_playing():
		return
	get_tree().quit()
