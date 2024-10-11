class_name Item extends Resource
enum ModType{ADDITIVE,MULTIPLICATIVE}

var name : String
var description : String
var modifiers : Array[Modifier]
var mod_type : ModType
var sprite_index : int = 0


#static func create(name : String, description : String, effects : Array[Modifier],sprite_index : int) -> Item:
	#return Item.new(name,description,effects,sprite_index)

func _init(item_name : String = "", descr : String = "", mods : Array[Modifier] = [],sprite_idx : int = 0, type :ModType = ModType.ADDITIVE) -> void:
	self.name = item_name
	self.description=descr
	self.modifiers = mods
	self.sprite_index = sprite_idx
	self.mod_type = type




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
