extends Node2D
class_name RandomItem

@onready var sprite: Sprite2D = $Visuals/Sprite2D

# TODO – Create weighted table for random items
# TODO – Create dedicated spritesheet for random items, allowing for simpler indexing into each frame
@export var random_items: RandomItems

#TODO remove, testing purposes
var modifier : ModifierData 


func _ready():
	set_item()


func set_item():
	if random_items == null:
		return
	
	var random_index = randi_range(0, (sprite.hframes * sprite.vframes) - 1)
	var item = random_items["items"][random_index]
	%ItemLabel.text = item["name"]
	sprite.frame = random_index
	
	#if item["name"] == "feather":
	modifier = ModifierData.new()
	modifier.name = "speed"
	modifier.duration = 2.0
	modifier.value = 2.5
