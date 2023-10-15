extends Node2D
@export var spawn_radius = 50
@export var max_mob_counts = 30
@onready var mobs = $Mobs

func gen_spawn_pos(): 
	var x = randf_range(-spawn_radius,spawn_radius)
	var y = randf_range(-spawn_radius,spawn_radius)
	return Vector2(x,y)
	
func spawn_mob(): 
	var mob = preload("res://Enemy/enemy.tscn").instantiate()
	var pos = gen_spawn_pos()
	mob.position =pos
	
	mobs.add_child(mob)


func _on_spawn_timer_timeout():
	if mobs.get_child_count() > max_mob_counts: 
		return 
	spawn_mob()
	
