extends Node2D
class_name LevelGate

@onready var particles: CPUParticles2D = $CPUParticles2D


func _ready():
	$Area2D.area_entered.connect(on_area_entered)


func on_area_entered(other_body: Node2D):
	var other_body_parent = other_body.get_parent()
	if not other_body_parent.is_in_group("player"):
		return
	
	var parent = get_parent() as Level
	
	if parent.level < EventManager.current_level:
		print("EventManager level_changed() signal has already been emitted for this level.")
		return
	particles.emitting = true
	EventManager.emit_level_changed()
