extends CanvasLayer

@onready var health_bar : HealthBar = $MarginContainer/HealthBar
@export var player : Player

func show_score_panel():
	$MarginContainer/Panel.visible=true
func hide_score_panel():
	$MarginContainer/Panel.visible=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not player:
		print("no player....")
		return
	health_bar.health_component=player.health_component
	#health_bar.initialize()

func _process(_delta : float):
	if $MarginContainer/Panel.visible:
		%Label.text = "Score: %d" % Game.score
# Called every frame. 'delta' is the elapsed time since the previous frame.
