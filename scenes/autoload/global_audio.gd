extends Node

const BUTTON_AUDIO_STREAMS = [
	preload("res://assets/sounds/ui_click_1.wav"),
	preload("res://assets/sounds/ui_click_2.wav"),
	preload("res://assets/sounds/ui_click_3.wav"),
	preload("res://assets/sounds/ui_click_4.wav"),
	preload("res://assets/sounds/ui_click_5.wav"),
]

var playback: AudioStreamPlaybackPolyphonic
var random_index_cache: Array[int] = []


func _enter_tree() -> void:
	var player = AudioStreamPlayer.new()
	player.bus = "Menu"
	player.volume_db = -5.0
	add_child(player)
	
	var stream = AudioStreamPolyphonic.new()
	stream.polyphony = 32
	player.stream = stream
	player.play()
	playback = player.get_stream_playback()
	
	get_tree().node_added.connect(_on_node_added)


func _get_random_audio_stream() -> AudioStream:
	if random_index_cache.size() == BUTTON_AUDIO_STREAMS.size():
		random_index_cache = []

	var upper_bound = BUTTON_AUDIO_STREAMS.size() - 1
	var random_index = randi_range(0, upper_bound)
	
	while random_index in random_index_cache:
		random_index = randi_range(0, upper_bound)
	
	random_index_cache.append(random_index)
	return BUTTON_AUDIO_STREAMS[random_index]


func _on_node_added(node: Node) -> void:
	if node is Button:
		node.mouse_entered.connect(_play_hover)
		node.pressed.connect(_play_pressed)


func _play_hover() -> void:
	playback.play_stream(_get_random_audio_stream(), 0, -16.0, 1)


func _play_pressed() -> void:
	playback.play_stream(_get_random_audio_stream(), 0, 0, 1)
