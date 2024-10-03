extends Node2D
class_name RandomItem

# TODO – Create a custom resource for RandomItem
# TODO – Refactor this scene using that custom resource
@onready var sprite: Sprite2D = $Visuals/Sprite2D
@export var id: int
@export var item_name: String
@export_multiline var item_description: String

# TODO – Create weighted table for random items
# TODO – Create dedicated spritesheet for random items, allowing for simpler indexing into each frame
const items: Array[Dictionary] = [
	{"frame": 2, "name": "Bread Person", "description": "What is up with this mysterious, sentient bread?"}, 
	{"frame": 3, "name": "Skullington", "description": "This skull is looking for his dad!"},
	{"frame": 4, "name": "Tooth or Horn or Something", "description": "You're not quite sure what it is, but it's sharp!"},
	{"frame": 8, "name": "Drop of Blood", "description": "What happens when you drink it?"},
	{"frame": 9, "name": "Funshroom", "description": "Eating this mushroom will make you see the world differently!"},
	{"frame": 10, "name": "Spotshroom", "description": "They say a mean, old dog is looking for these!"},
	{"frame": 11, "name": "Key", "description": "This opens a locked something-or-other!"},
	{"frame": 12, "name": "Giant Coffee Bean", "description": "Did you know that coffee beans are fruits?"},
	{"frame": 16, "name": "Feather", "description": "At least, it's supposed to be a feather."},
	{"frame": 17, "name": "Leaf", "description": "Where did it come from?"},
	{"frame": 18, "name": "Jumpshroom", "description": "Jump on these bad boys for a good time!"},
	{"frame": 19, "name": "Approximately", "description": "Neither here nor there, as the kids are saying these days."},
	{"frame": 20, "name": "Divide", "description": "...and conquer!"}
]

var is_in_reach = false


func _ready():
	set_item()
	$Area2D.area_entered.connect(on_area_entered)
	$Area2D.area_exited.connect(on_area_exited)


func set_item():
	var item = items.pick_random()
	sprite.frame = item["frame"]
	%ItemLabel.text = item["name"]
	%PickUpLabel.text = item["description"]


func toggle_label_visibility():
	%PickUpLabel.visible = !%PickUpLabel.visible
	%ItemLabel.visible = !%ItemLabel.visible


func on_area_entered(other_area: Area2D):
	if not other_area.is_in_group("player"):
		return
	toggle_label_visibility()
	is_in_reach = true


func on_area_exited(other_area: Area2D):
	if not other_area.is_in_group("player"):
		return
	toggle_label_visibility()
	is_in_reach = false
