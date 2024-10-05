extends Area2D
class_name HurtBoxComponent

@export var health_component: HealthComponent


func _ready():
	area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D):
	print(other_area.name, "Here")
	if not is_instance_of(other_area,HitBoxComponent):
		return
	
	if health_component == null:
		return
	var hit_box_component = other_area as HitBoxComponent
	health_component.damage(hit_box_component.damage,10)
