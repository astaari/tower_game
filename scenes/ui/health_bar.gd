extends Control

@onready var progress_bar = $TextureProgressBar
@export var health_component : HealthComponent

const overlays : Dictionary = {
	"full": preload("res://assets/ui/health-bar-overlay-full.png"),
	"half":	preload("res://assets/ui/health-bar-overlay-half.png"),
	"low" : preload("res://assets/ui/health-bar-overlay-low.png"),
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player and not health_component:
		health_component=player.health_component
	if health_component:
		progress_bar.max_value = health_component.max_health
		progress_bar.value = health_component.current_health
		health_component.health_changed.connect(_on_health_changed)

func _on_health_changed(value):
	progress_bar.value = value
	var percent : float = health_component.percent_remaining()
	if percent > 0.66:
		progress_bar.texture_over = overlays["full"]
	elif percent > 0.33:
		progress_bar.texture_over = overlays["half"]
	else:
		progress_bar.texture_over = overlays["low"]
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
