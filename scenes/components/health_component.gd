extends Node
class_name HealthComponent

signal died
signal health_changed(current)

@export var max_health: float = 100
var current_health : float 


func _ready():
	current_health = max_health


func damage(damage_amount: float):
	current_health = max(current_health - damage_amount, 0)
	health_changed.emit(current_health)
	Callable(check_death).call_deferred()
func heal(heal_amount : float) -> void:
	current_health = min(current_health+heal_amount,max_health)
	health_changed.emit(current_health)
	
	
func percent_remaining() -> float:
	return current_health / max_health

func check_death():
	if current_health <= 0:
		died.emit()
		owner.queue_free()
