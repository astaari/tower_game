class_name Effect extends Modifier


@export_range(0,600) var duration : float = 0.0


func _init(prop_name : String = "",val : float= 0.0,dur : float = 0.0):
	super._init(prop_name,val)
	self.duration=dur
