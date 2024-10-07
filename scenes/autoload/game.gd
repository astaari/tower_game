extends Node

@onready var items : RandomItems = RandomItems.new()


func _ready():
	for i in range(100):
		items.get_random_item()
