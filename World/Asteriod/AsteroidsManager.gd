extends Node

@export var max_asteroids = 30


func spawn_algo(): 
	var size = Asteroid.AsteroidSize.LARGE
	var pos = Vector2.ZERO 
	pos.x=randf_range(0,Global.GAME_WIDTH)
	pos.y=randf_range(0,Global.GAME_HEIGHT)
	spawn_asteroid(pos,size)
	
func _on_asteroid_exploded(pos, size):
	for i in range(2):
		match size:
			Asteroid.AsteroidSize.LARGE:
				spawn_asteroid(pos, Asteroid.AsteroidSize.MEDIUM)
			Asteroid.AsteroidSize.MEDIUM:
				spawn_asteroid(pos,Asteroid.AsteroidSize.SMALL)

func spawn_asteroid(pos, size):
	var a = preload("res://World/Asteriod/Asteroid.tscn").instantiate()
	a.connect("exploded", _on_asteroid_exploded)
	a.size = size
	add_child(a)
	a.global_position = pos
