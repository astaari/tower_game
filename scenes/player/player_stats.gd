class_name PlayerStats extends Resource


@export var speed : float = 300
@export var max_health = 100 :
	set(value):
		max_health = value
		if _player:
			_player.health_component.max_health=value
			
@export var jump_height : float = 100
@export var damage : float = 2.0
@export var damage_resist : float = 0.0 :
	set(value):
		damage_resist = clampf(value,-0.25,0.75)
		if _player:
			_player.health_component.damage_resist = damage_resist
@export var projectiles_max: int = 500
@export var character_size : float = 1.0 :
	set(value):
		character_size = clampf(value,0.25,2.0)
		if _player:
			_player.scale = Vector2(character_size,character_size).clamp(Vector2(0.25,0.25),Vector2(2.0,2.0))
@export var attack_speed = 3.5:
	set(value):
		attack_speed = clampf(value,0.2,5.0)
		if _player:
			_player.get_node("AttackTimer").wait_time = attack_speed
var _player : Player


func register(player : Player):
	_player = player

func unregister():
	_player = null


func _to_string() -> String:
	var str : String = "Player Stats: \n"
	if _player:
		str += "\t Max Health : %.2f\n" % _player.health_component.max_health
	for prop in Game.player_stats:
		str += "\t" + prop.replace("_"," ").capitalize() + " : " + str(self.get(prop)) + "\n"
		
	return str


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
				max_health += modifier.value
				if modifier.value > 0:
					health.heal(modifier.value)
			else:
				health.heal(modifier.value)
			
	
		#(get_local_scene() as Player).get_node("HealthComponent").heal(modifier.value)
	elif modifier.property_name in self:
		var old = self.get(modifier.property_name)
		var new = old + modifier.value
		print(old, " , ", new)
		self.set(modifier.property_name,new)
