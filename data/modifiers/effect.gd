class_name Effect extends Modifier


@export_range(0,600) var duration : float = 1.0


func _init(property_name : String,value : float,duration : float):
	super._init(property_name,value)
	self.duration=duration
