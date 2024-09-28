extends PanelContainer

@export var level_number: int
@export var level: PackedScene
@export var is_unlocked: bool = false

@onready var level_button: Button = %LevelButton

const LOCK_ICON = preload("res://assets/icons/lock.png")


func _ready() -> void:
	level_button.pressed.connect(on_level_button_pressed)
	set_level_button()


func set_level_button():
	level_button.disabled = !is_unlocked
	if is_unlocked:
		level_button.icon = null
		level_button.text = str(level_number)
	else:
		level_button.icon = LOCK_ICON
		level_button.text = ""


func on_level_button_pressed():
	print("You clicked on level " + str(level_number) + " and is_unlocked is " + str(is_unlocked) + " and disabled is " + str(level_button.disabled))
