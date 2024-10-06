extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var json : JSON = JSON.new()
	var jsonparse = json.parse_string(FileAccess.open("res://test.json",FileAccess.READ).get_as_text())
	print(jsonparse)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
