extends Node2D


signal hp_changed

@export var max_hp = 1000

var hp = max_hp: set = set_hp 

func set_hp(val): 
	hp = val
	hp_changed.emit(hp)
	
	if hp <= 0: 
		hp = 0
		
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
