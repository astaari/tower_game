extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visibility_changed.connect(_update_text)
	%ConfirmButton.pressed.connect(func():
		Game.call_deferred("unblock_pause")
		
		EventManager.to_main_menu()
		Game.pause()
		#self.visible = false
		)
	%CancelButton.pressed.connect(func():
		$Control.visible = false
		Game.call_deferred("unblock_pause")
		)
	%MenuButton.pressed.connect(func():
		Game.block_pause()
		
		$Control.visible=true
		)
	


func _update_text() -> void:
	if visible:
		%Label.text = Game.get_player_stats()
		#%Label.text += "\n Score : %d" % Game.score 
# Called every frame. 'delta' is the elapsed time since the previous frame.
