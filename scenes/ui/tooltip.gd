class_name Tooltip extends Panel

@export var item : Item 
@export var modifiers : Array[Modifier]
var label_scene : PackedScene = preload("res://scenes/ui/game_label.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not item:
		%ItemName.set_text("No Item data :(")
		return
	
	modifiers = item.modifiers
	%ItemName.set_text(item.name)
	%ItemName._check_line_count()
	for mod in modifiers:
		print(mod)
		var label : Label = label_scene.instantiate()
		label.custom_minimum_size = Vector2(160,16)
		label.set_text(str(mod))
		
		label.update_minimum_size()
		label._check_line_count()
		%Modifiers.add_child(label)
	tooltip_text=item.description


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
