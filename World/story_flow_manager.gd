extends Node2D

var stage = 1
var w: World = null 
var origin_spawners_count = null
var spawners_killed = 0

func _initialize_(_w:World): 
	w = _w 
	origin_spawners_count = w.spawners.get_child_count()
	Global.spawner_destroyed.connect(_on_spawner_destroyed)

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
		
		var boss = w.spawn_boss()
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
