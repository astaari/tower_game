extends Resource
signal effect_expired(effect,value)

var _active : Dictionary = {}

func apply_effect(name : String, value) -> bool:
	if name not in _active:
		_active.apply()
