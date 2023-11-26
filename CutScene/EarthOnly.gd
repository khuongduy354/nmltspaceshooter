extends Node2D


func _physics_process(delta):
	for sprite in $Sprites.get_children(): 
		var dir = Vector2.UP.rotated(sprite.rotation)
		sprite.position += dir * 0.2
	for sprite in $Sprites2.get_children(): 
		var dir = Vector2.DOWN.rotated(sprite.rotation)
		sprite.position += dir * 0.2
