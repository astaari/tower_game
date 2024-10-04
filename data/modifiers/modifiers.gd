class_name Modifiers extends Node
signal effect_expired(effect)

var _active : Dictionary = {}
var _timers : Dictionary = {}
func remove_modifier(name : String):
	effect_expired.emit(_active.get(name))
	_active.erase(name)

func get_modifier(name : String) -> ModifierData:
	return _active.get(name)


func _refresh_duration(modifier_name : String):
	(_timers[modifier_name] as SceneTreeTimer).time_left = _active[modifier_name].duration


func apply_modifier(modifier : ModifierData) -> bool:
	if modifier.name not in _active:
		_active[modifier.name] = modifier
		if modifier.duration > 0:
			var timer = get_tree().create_timer(modifier.duration)
			timer.timeout.connect(
			func():
				remove_modifier(modifier.name)
				_timers.erase(modifier.name)
				)
		return true
	return false
		#_active.apply()
