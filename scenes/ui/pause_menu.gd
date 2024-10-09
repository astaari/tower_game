extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visibility_changed.connect(_update_text)

func _update_text() -> void:
	if visible:
		%Label.text = Game.get_player_stats()
		%Label.text += "\n Score : %d" % Game.score 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
