class_name Modifier extends Resource

@export_group("modifier")
@export var property_name : String
@export var value : float

func _init(property_name : String = "",value : float=0):
	self.property_name=property_name
	self.value=value


func _to_string() -> String:
	var str : String = property_name.replace("_"," ")
	str = str.capitalize()
	var sign = "+" if value > 0 else ""
	str += ": " + sign+  str(value)
	return str
