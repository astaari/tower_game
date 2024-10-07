class_name Item extends Resource

var name : String
var description : String
var modifiers : Array[Modifier]
var sprite_index : int = 0


#static func create(name : String, description : String, effects : Array[Modifier],sprite_index : int) -> Item:
	#return Item.new(name,description,effects,sprite_index)

func _init(name : String, description : String, effects : Array[Modifier],sprite_index : int) -> void:
	self.name = name
	self.description=description
	self.effects = effects
	self.sprite_index = sprite_index




func get_effect_modifiers() -> Array[Effect]:
	var result  : Array[Effect] = []
	for mod in modifiers:
		if is_instance_of(mod,Effect):
			result.append(mod as Effect)
	return result

func get_normal_modifiers() -> Array[Modifier]:
	var result : Array[Modifier] = []
	for mod in modifiers:
		if not is_instance_of(mod,Effect):
			result.append(mod)
	return result
