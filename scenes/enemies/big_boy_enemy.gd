extends Enemy

 

func _movement(delta : float) -> Vector2:
	var movement : Vector2 = Vector2.ZERO
	
	movement.y = velocity.y
	$AnimationPlayer.stop()
	#print(velocity)
	return movement
