extends Node2D
class_name RandomItem

@onready var sprite: Sprite2D = $Visuals/Sprite2D
#@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

# TODO – Create weighted table for random items
#@export var random_items: RandomItems
var tooltip : Tooltip


#TODO remove, testing purposes
var item : Item
var modifiers : Array[Modifier]
var item_id : int = -1


func _ready():
	set_item()


func set_item():
	if Game.items == null:
		return
	
	#var random_index = randi_range(0, (sprite.hframes * sprite.vframes) - 1)
	#var item = random_items["items"][random_index]
	
	item = Game.items.get_random_item()
	item_id = item.sprite_index
	%ItemLabel.text = item["name"]
	sprite.frame = item_id
	self.modifiers = item.modifiers
	#if item["name"] == "feather":
	#modifier = Modifier.new()
	#modifier.name = "speed"
	#modifier.duration = 2.0
	#modifier.value = 2.5

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		pass
		#if not Game.tooltip_is_visible():
			#Game.show_tooltip(self)
		#tooltip = Game.tooltip_scene.instantiate() as Tooltip
		#tooltip.item = self.item
		#tooltip.position.y+=-300
		#add_child(tooltip)
		


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		#if Game.current_tooltip.item == self.item:
			#Game.hide_tooltip()
		pass
		
		#tooltip.queue_free()
		#tooltip = null
