extends Node2D
class_name RandomItem

@onready var sprite: Sprite2D = $Visuals/Sprite2D

# TODO – Create weighted table for random items
@export var random_items: RandomItems

#TODO remove, testing purposes
var modifier : Modifier
var item_id : int = -1


func _ready():
	set_item()


func set_item():
	if random_items == null:
		return
	
	var random_index = randi_range(0, (sprite.hframes * sprite.vframes) - 1)
	#var item = random_items["items"][random_index]
	
	var item = random_items.get_random_item()
	item_id = item.sprite_index
	%ItemLabel.text = item["name"]
	sprite.frame = item_id
	
	#if item["name"] == "feather":
	#modifier = Modifier.new()
	#modifier.name = "speed"
	#modifier.duration = 2.0
	#modifier.value = 2.5
