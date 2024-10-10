extends Area2D
signal player_in_range(player)
signal player_out_of_range

func _ready()->void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range.emit(body as Player)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_out_of_range.emit()
	pass # Replace with function body.
