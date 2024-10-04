class_name Modifiers extends Node
signal effect_expired(effect)

var _active : Dictionary = {}
var _timers : Dictionary = {}


func remove_modifier(modifier_name : String):
	effect_expired.emit(_active.get(modifier_name))
	_active.erase(modifier_name)


func get_modifier(modifier_name : String) -> ModifierData:
	return _active.get(modifier_name)


func _refresh_duration(modifier_name : String):
	(_timers[modifier_name] as SceneTreeTimer).time_left = _active[modifier_name].duration

func extend_modifier(name : String, duration : float):
	var timer : SceneTreeTimer = _timers.get(name)
	if timer:
		timer.time_left+=duration
	
func shorten_modifier(name : String, decrease : float):
	var timer : SceneTreeTimer = _timers.get(name)
	if timer:
		timer.time_left -= decrease

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
