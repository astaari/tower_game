class_name Modifier extends Resource

@export_group("modifier")
@export var property_name : String
@export var value : float

func _init(property_name : String,value : float):
	self.property_name=property_name
	self.value=value
