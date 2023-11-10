extends CanvasLayer

@onready var bulletcount = $MarginContainer/VBoxContainer/BulletCount

func set_bullet(val:int): 
	bulletcount.text = str(val)
