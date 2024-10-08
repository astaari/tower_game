class_name PlayerStats extends Resource


@export var speed : float = 300
@export var jump_height : float = 100
@export var damage : float = 2.0
@export var damage_resist : float = 0.0



func jump_height_to_speed() -> float:
	var gravity = ProjectSettings.get("physics/2d/default_gravity")
	var time_to_max : float = 12
	var result_vel = -sqrt(2*gravity*jump_height)
	return result_vel


func apply_modifier(modifier : Modifier):
	if modifier == null:
		print("NULL mod")
		return
	if modifier.property_name in self:
		var old = self.get(modifier.property_name)
		var new = old + modifier.value
		print(old, " , ", new)
		self.set(modifier.property_name,new)
