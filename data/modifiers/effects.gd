class_name Effects extends Node
signal effect_expired(effect)

var _active : Dictionary = {}
var _timers : Dictionary = {}


func remove_effect(effect_name : String):
	effect_expired.emit(_active.get(effect_name))
	_active.erase(effect_name)


func get_effect(effect_name : String) -> Modifier:
	return _active.get(effect_name)


func _refresh_duration(effect_name : String):
	(_timers[effect_name] as SceneTreeTimer).time_left = _active[effect_name].duration


func extend_effect(effect_name : String, duration : float):
	var timer : SceneTreeTimer = _timers.get(effect_name)
	if timer:
		timer.time_left+=duration


func shorten_effect(effect_name : String, decrease : float):
	var timer : SceneTreeTimer = _timers.get(effect_name)
	if timer:
		timer.time_left -= decrease

func apply_effect(effect : Effect) -> bool:
	if effect.name not in _active:
		_active[effect.name] = effect
		if effect.duration > 0:
			var timer = get_tree().create_timer(effect.duration)
			timer.timeout.connect(
			func():
				remove_effect(effect.name)
				_timers.erase(effect.name)
				)
		return true
	return false
		#_active.apply()
