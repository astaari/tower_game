class_name PlayerStats extends Resource


@export var speed : float = 300
@export var jump_height : float = 100
@export var damage : float = 2.0
@export var damage_resist : float = 0.0

var _player : Player


func register(player : Player):
	_player = player

func unregister():
	_player = null




func jump_height_to_speed() -> float:
	var gravity = ProjectSettings.get("physics/2d/default_gravity")
	var time_to_max : float = 12
	var result_vel = -sqrt(2*gravity*jump_height)
	return result_vel


func apply_modifier(modifier : Modifier):
	if modifier == null:
		print("NULL mod")
		return
	if "health"in modifier.property_name:
		if _player:
			var health = _player.get_node("HealthComponent") as HealthComponent
			if modifier.property_name=="max_health":
				health.max_health += modifier.value
				health.heal(modifier.value)
			else:
				health.heal(modifier.value)
			
	
		#(get_local_scene() as Player).get_node("HealthComponent").heal(modifier.value)
	elif modifier.property_name in self:
		var old = self.get(modifier.property_name)
		var new = old + modifier.value
		print(old, " , ", new)
		self.set(modifier.property_name,new)
