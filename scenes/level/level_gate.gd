extends Node2D


func _ready() -> void:
	$Area2D.area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D):
	if not other_area.is_in_group("player"):
		return
	
	print("End level")
