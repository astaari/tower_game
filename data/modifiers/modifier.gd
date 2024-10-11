class_name Modifier extends Resource

@export_group("modifier")
@export var property_name : String
@export var value : float

func _init(prop_name : String = "",val : float=0):
	self.property_name=prop_name
	self.value=val


func _to_string() -> String:
	var res : String = property_name.replace("_"," ")
	res = res.capitalize()
	var val_sign = "+" if value > 0 else ""
	res += ": " + val_sign+  str(value)
	return res
