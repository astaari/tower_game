extends Node

signal level_changed()
signal item_picked_up()

var current_level: int = -1


func to_main_menu() ->void:
	current_level=-2
	if Game.player:
		Game.player.reset_player()
	emit_level_changed()

func emit_level_changed():
	current_level += 1
	level_changed.emit()


func emit_item_picked_up(item_name: String):
	item_picked_up.emit(item_name)
	
