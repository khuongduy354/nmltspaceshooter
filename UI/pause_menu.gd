extends CanvasLayer

func _physics_process(delta):
	if Input.is_action_just_pressed("pause"): 
		_on_resume_pressed()

func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
	pass # Replace with function body.


func _on_resume_pressed():
	self.visible = false
	set_physics_process(false)
	get_tree().paused = false
	pass # Replace with function body.



func _on_music_slider_value_changed(value):
	Global.set_master_db(value)
		


func _on_exit_pressed():
	get_tree().quit()
