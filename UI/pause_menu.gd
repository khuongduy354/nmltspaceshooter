extends CanvasLayer


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
	pass # Replace with function body.


func _on_resume_pressed():
	self.visible = false
	get_tree().paused = false
	pass # Replace with function body.


func _on_replay_pressed():
	pass # Replace with function body.
