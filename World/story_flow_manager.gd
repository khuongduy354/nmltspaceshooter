extends Node2D

var stage = 1
var w: World = null 
var origin_spawners_count = null
var spawners_killed = 0

func _initialize_(_w:World): 
	w = _w 
	origin_spawners_count = w.spawners.get_child_count()
	Global.spawner_destroyed.connect(_on_spawner_destroyed)
func _on_boss_killed():
	Global.destroyed_bosses += 1
	await get_tree().create_timer(5).timeout 
	Global.fade_left_trans_to("res://UI/story_game_win.tscn")
func custom_spawn_boss(): 
	var boss = preload("res://Enemy/Boss.tscn").instantiate()
	boss._initialize_(w.player)
	boss.global_position = w.get_node("Positions").get_node("boss_spawn").global_position
	boss.spawned_mob.connect(func(): Global.mobs_count += 1)
	boss.destroyed.connect(_on_boss_killed)
	

	add_child(boss)
	boss.fsm.spawn_count = 3
	for gun in boss.guns.get_children(): 
		gun.custom_bullet_speed = 2000
	return boss 
func _on_spawner_destroyed(): 
	spawners_killed +=1
	if spawners_killed == origin_spawners_count: 
		await get_tree().create_timer(1).timeout
		
		w.player.cam.enabled = false
		var camdup = w.player.cam.duplicate()
		camdup.position_smoothing_enabled = false		
		add_child(camdup)
		var origin_cam_pos = w.player.cam.global_position
		camdup.global_position = origin_cam_pos
		camdup.enabled=true
		
		var boss = custom_spawn_boss()
		boss.set_physics_process(false)
		var target = boss.global_position
		camdup.move_to(target)
		
		await get_tree().create_timer(5).timeout
		
		camdup.move_to(origin_cam_pos)
		await get_tree().create_timer(2).timeout
		camdup.queue_free()
		w.player.cam.enabled = true
		boss.set_physics_process(true)		
		
		stage = 2	
