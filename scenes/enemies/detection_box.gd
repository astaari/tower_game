extends Area2D
signal player_in_range(player)
signal player_out_of_range


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range.emit(body as Player)


func _on_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
