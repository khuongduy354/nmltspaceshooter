extends Node2D
@onready var sprite1 = $kepler_spinning/Sprites
@onready var sprite2 = $mars_spinning/Sprites2

func _physics_process(delta):
	for sprite in sprite1.get_children(): 
		var dir = Vector2.UP.rotated(sprite.rotation)
		sprite.position += dir * 0.1
	for sprite in sprite2.get_children(): 
		var dir = Vector2.DOWN.rotated(sprite.rotation)
		sprite.position += dir * 0.1
