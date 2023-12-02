extends Node2D


signal hp_changed

@onready var spawn_timer = $spawn_interval

@export var max_hp = 1000

var hp = max_hp: set = set_hp 

func set_hp(val): 
	hp = val
	hp_changed.emit(hp)
	
	if hp <= 0: 
		hp = 0
		
	
func spawn_boss(): 
	var boss = preload("res://Enemy/Boss.tscn").instantiate()
	boss.spawned_mob.connect(func(): Global.mobs_count += 1)
	boss.destroyed.connect(func(): Global.destroyed_bosses += 1)
	
	if Global.player: 
		boss._initialize_(Global.player)
		
	$Bosses.add_child(boss)
	
	boss._initialize_(Global.player)
	boss.global_position = $boss_spawn.global_position

func _on_spawn_interval_timeout():
	spawn_boss()
