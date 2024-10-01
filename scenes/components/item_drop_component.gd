extends Node

@export_range(0, 1) var drop_percent: float = 0.5
@export var health_component: Node
@export var item_scene: PackedScene

# var item_table = WeightedTable.new()
# Bullshit strings in lieu of the completed weighted table
var random_strings: Array[String] = ["mango", "coin", "diaper", "diamond", "zebra", "monkey", "child", "Playstation 5", "lamp"]


func _ready():
	(health_component as HealthComponent).died.connect(on_died)


func on_died():
	if randf() > drop_percent:
		return 
	
	if item_scene == null:
		return
	
	if not owner is Node2D:
		return
	
	var item_name = random_strings.pick_random()
	
	var spawn_position = (owner as Node2D).global_position
	var item_instance = item_scene.instantiate() as Node2D
	item_instance.item_name = item_name
	owner.get_parent().add_child(item_instance)
	item_instance.global_position = spawn_position
