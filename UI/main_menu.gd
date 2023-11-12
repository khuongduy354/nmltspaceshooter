extends CanvasLayer

@onready var sound_edit = $Background/SoundEdit
@onready var pname_form = $Background/PlayerName 

func _on_exit_button_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_soundsetting_button_pressed():
	sound_edit.visible = true  
	pass # Replace with function body.


func _on_startgame_button_pressed():
	Global.player_name =  pname_form.text
	get_tree().change_scene_to_file("res://World/world.tscn")
	pass # Replace with function body.


func _on_done_pressed():
	sound_edit.visible = false  
	pass # Replace with function body.
