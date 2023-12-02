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
	Global.is_story = true
	Global.fade_left_trans_to("res://World/game.tscn")


func _on_done_pressed():
	sound_edit.visible = false  
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_endless_game_button_pressed():
	Global.player_name =  pname_form.text
	Global.is_story = false
	Global.fade_left_trans_to("res://World/game.tscn")


func _on_check_box_toggled(button_pressed):
	Global.is_wasd = button_pressed


func _on_music_slider_value_changed(value):
	Global.set_master_db(value)
