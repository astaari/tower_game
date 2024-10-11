class_name WaveUi extends CanvasLayer

@onready var wavenum_label : Label = %WaveNum
@onready var wavetime_label : Label = %WaveTime

const during_text : String = "Time Left: %.2f"
const wait_text : String = "Next Wave: %d"
# Called when the node enters the scene tree for the first time.
