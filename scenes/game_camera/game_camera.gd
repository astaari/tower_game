extends Camera2D

var target_position = Vector2.ZERO
var y_offset = -200


func _ready():
	make_current()


func _process(delta):
	set_target_position()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 20.0))


func set_target_position():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node == null:
		print("NO PLAYER")
		return
	target_position = player_node.global_position
	target_position.y += y_offset
