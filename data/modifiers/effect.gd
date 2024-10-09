class_name Effect extends Modifier


@export_range(0,600) var duration : float = 0.0


func _init(property_name : String = "",value : float= 0.0,duration : float = 0.0):
	super._init(property_name,value)
	self.duration=duration
