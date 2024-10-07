class_name PlayerStats extends Resource

@export var speed : float = 300

@export var jump_height : float = 100


func jump_height_to_speed() -> float:
	var gravity = ProjectSettings.get("physics/2d/default_gravity")
	var time_to_max : float = 12
	var result_vel = -sqrt(2*gravity*jump_height)
	return result_vel
