extends Node2D
class_name LevelGate


func _ready():
	$Area2D.area_entered.connect(on_area_entered)


func on_area_entered(other_body: Node2D):
	var parent = other_body.get_parent()
	if not parent.is_in_group("player"):
		return
	
	var current_level = get_parent() as Level
	
	if current_level.level < EventManager.current_level:
		print("EventManager level_changed() signal has already been emitted for this level.")
	
	EventManager.emit_level_changed()
