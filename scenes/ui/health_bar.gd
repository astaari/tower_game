extends Control

@onready var progress_bar = $TextureProgressBar
@export var health_component : HealthComponent

const overlays : Dictionary = {
	"full": preload("res://assets/ui/health-bar-overlay-full.png"),
	"half":	preload("res://assets/ui/health-bar-overlay-half.png"),
	"low" : preload("res://assets/ui/health-bar-overlay-low.png"),
}


func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player and not health_component:
		health_component = player.health_component
	if health_component:
		%Label.text = str(health_component.current_health, "/", health_component.max_health)
		progress_bar.max_value = health_component.max_health
		progress_bar.value = health_component.current_health
		health_component.health_changed.connect(_on_health_changed)
		health_component.max_health_changed.connect(_on_max_health_changed)
		health_component.died.connect(
			func():
			health_component.health_changed.disconnect(_on_health_changed)
			health_component.max_health_changed.disconnect(_on_max_health_changed)
			health_component = null
			)

func _update():
	if not health_component:
		return
	var percent : float = health_component.percent_remaining()
	if percent > 0.66:
		progress_bar.texture_over = overlays["full"]
	elif percent > 0.33:
		progress_bar.texture_over = overlays["half"]
	else:
		progress_bar.texture_over = overlays["low"]

func _on_health_changed(value):
	progress_bar.value = value
	_update()
	%Label.text = str(value, "/", health_component.max_health)
	
func _on_max_health_changed(value : float)-> void:
	progress_bar.max_value = value
	_update()
