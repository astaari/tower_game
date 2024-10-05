extends Node2D
class_name LevelGate


func _ready():
	$Area2D.area_entered.connect(on_area_entered)


func on_area_entered(other_body: Node2D):
	var parent = other_body.get_parent()
	if not parent.is_in_group("player"):
		return
	
	print("Level completed!")
