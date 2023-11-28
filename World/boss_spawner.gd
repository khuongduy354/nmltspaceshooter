extends Node2D

func _ready(): 
	spawn_boss()
	
func spawn_boss(): 
	var boss = preload("res://Enemy/Boss.tscn").instantiate()
	boss._initialize_(Global.player)
	boss.global_position = $boss_spawn.global_position
	boss.spawned_mob.connect(func(): Global.mobs_count += 1)
	boss.destroyed.connect(func(): Global.destroyed_bosses += 1)
	
	$Bosses.add_child(boss)


func _on_spawn_interval_timeout():
	spawn_boss()
	pass # Replace with function body.
