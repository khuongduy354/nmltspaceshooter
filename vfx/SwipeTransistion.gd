extends CanvasLayer


@onready var animp = $AnimationPlayer
var file  = null 

signal opened 
signal closed

func transition_to(_file: String):
	file = _file
	set_deferred("visible",true)
	animp.play("close")




func _on_animation_player_animation_finished(anim_name):
	if anim_name == "close":
		closed.emit()
	if anim_name == "open": 
		opened.emit() 
		visible = false 
