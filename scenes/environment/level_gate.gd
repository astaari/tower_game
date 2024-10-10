extends Node2D
class_name LevelGate

@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready():
	$Area2D.area_entered.connect(on_area_entered)


func on_area_entered(other_body: Node2D):
	var other_body_parent = other_body.get_parent()
	if not other_body_parent.is_in_group("player"):
		return
	
	var parent = get_parent() as Level
	
	if parent.level < EventManager.current_level:
		print("EventManager level_changed() signal has already been emitted for this level.")
		print("Current Level: ", EventManager.current_level)
		return
	
	var audio_fade_tween = create_tween()
	audio_fade_tween.tween_property(audio_stream_player, "volume_db", -80, 6).set_ease(Tween.EASE_IN)
	particles.emitting = true
	EventManager.emit_level_changed()
