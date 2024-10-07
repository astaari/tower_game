extends Node

var _add_modifiers : Dictionary = {}
var _mult_modifiers : Dictionary = {}


func get_add_modifier(name : String) -> Modifier:
	return _add_modifiers.get(name)
func get_mult_modifier(name : String) -> Modifier:
	return _mult_modifiers.get(name)

func increase_add_modifier(modifier : Modifier) ->void:
	if modifier.name in _add_modifiers:
		(_add_modifiers[modifier.name] as Modifier).value+=modifier.value
	else:
		_add_modifiers[modifier.name] = modifier

func increase_mult_modifier(modifier : Modifier) -> void:
	if modifier.name in _mult_modifiers:
		(_mult_modifiers[modifier.name] as Modifier).value+=modifier.value
	else:
		_mult_modifiers[modifier.name] = modifier
