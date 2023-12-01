extends Node2D
class_name World

@onready var player: Player = null 
@onready var spawners = $Spawners
@onready var asteroids = $Asteroids 
@onready var entity_pos = $Positions

@onready var gflow = $GameFlowManager
@onready var playerUI = $PlayerUI
@onready var pause_menu = $PauseMenu

@onready var timer_start = Time.get_unix_time_from_system()
	
func premade_setup(): 
	# setup game_flow
	gflow._initialize_(self)
	setup_player()
	setup_spawners()
	spawn_asteroids()
	pause_menu.set_physics_process(false)
	reset_global_params()

func _physics_process(delta):
	if Input.is_action_just_pressed("pause"): 
		get_tree().paused = true
		pause_menu.visible=true 
		pause_menu.set_physics_process(true)
		
	# set time played 
	var time_now = Time.get_unix_time_from_system() - timer_start
	playerUI.set_time(time_now)	

# helpers
func spawn_asteroids(): 
	while asteroids.get_child_count() < asteroids.max_asteroids: 
		asteroids.spawn_algo()
	
 
func spawn_boss(): 
	var boss = preload("res://Enemy/Boss.tscn").instantiate()
	boss._initialize_(player)
	boss.global_position = $Positions/boss_spawn.global_position
	boss.spawned_mob.connect(func(): Global.mobs_count += 1)
	boss.destroyed.connect(func(): Global.destroyed_bosses += 1)
	
	add_child(boss)
	return boss 

func setup_player(): 
	player = preload("res://Player/player.tscn").instantiate()
	player.wasd_control = Global.is_wasd
	playerUI.set_max_health(player.max_health)
	playerUI.set_health(player.max_health)
	player.health_changed.connect(playerUI.set_health)
	
	
	add_child(player)
	player.global_position = $Positions/player_spawn.global_position
	
func reset_global_params(): 
	Global.player = player
	Global.cam = player.cam
	Global.destroyed_mobs = 0 
	Global.mobs_count = 0
	Global.destroyed_bosses = 0 

func setup_spawners(): 
	for spawner in spawners.get_children(): 
		spawner.spawned_mob.connect(func(): Global.mobs_count+=1)

# signals
func _on_asteroid_check_timeout():
	spawn_asteroids()
	pass # Replace with function body.
