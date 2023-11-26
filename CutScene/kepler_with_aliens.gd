extends Node2D

func _ready():
	for enemy in $Enemies.get_children(): 
		enemy.set_physics_process(false)

func _physics_process(delta):
	for enemy in $Enemies.get_children(): 
		var dir = Vector2.RIGHT.rotated(enemy.rotation)
		enemy.position += dir * .3
	
