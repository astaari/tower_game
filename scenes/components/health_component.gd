extends Node
class_name HealthComponent

signal died
signal health_changed(current)
signal max_health_changed(max_health)

@export var max_health: float = 100 :
	set(val):
		var diff = val-max_health
		max_health=val
		
		max_health_changed.emit(val)
		if current_health+diff > 0:
			heal(diff)
	get():
		return max_health
var current_health : float 
var damage_resist : float = 0.0
var damage_immune : bool = false
@export var immune_time : float = 0.25
const tween_curve : Curve = preload("res://data/constant.tres")
func _ready():
	current_health = max_health


func damage(damage_amount: float, _knockback: float = 0):
	if damage_immune:
		return
	damage_amount*=(1-damage_resist)
	current_health = max(current_health - damage_amount, 0)
	health_changed.emit(current_health)
	get_tree().create_timer(immune_time).timeout.connect(
		func():
			damage_immune=false
	)
	damage_immune = true
	var tween = get_tree().create_tween()
	var sprite = get_parent().get_node("Sprite2D")
	if sprite:
		tween.tween_property(sprite,"self_modulate",Color.BLACK,immune_time/4).set_custom_interpolator(_interp_damage_tween)
		tween.tween_property(sprite,"self_modulate",Color.WHITE,immune_time/4).set_custom_interpolator(_interp_damage_tween)
		#tween.tween_property(sprite,"self_modulate",Color.BLACK,immune_time/4).set_custom_interpolator(_interp_damage_tween)
		#tween.tween_property(sprite,"self_modulate",Color.WHITE,immune_time/4).set_custom_interpolator(_interp_damage_tween)
		
	Callable(check_death).call_deferred()

func _interp_damage_tween(v):
	return tween_curve.sample_baked(v)

func heal(heal_amount : float) -> void:
	current_health = min(current_health+heal_amount,max_health)
	health_changed.emit(current_health)


func percent_remaining() -> float:
	return current_health / max_health


func check_death():
	if current_health <= 0:
		died.emit()
		owner.queue_free()
