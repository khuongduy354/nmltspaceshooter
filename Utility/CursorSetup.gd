extends Node

var cdot = preload("res://assets/UI/Crosshair/PNG/White Retina/crosshair038.png")

func _ready():
	Input.set_custom_mouse_cursor(cdot,0,Vector2(64,64))
