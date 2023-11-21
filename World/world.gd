extends Node2D
class_name World

@onready var boss: BossI = null 
@onready var player: Player = null 
@onready var spawners = $Spawners
@onready var asteroids = $Asteroids 

@onready var gflow = $GameFlowManager
@onready var playerUI = $PlayerUI
@onready var pause_menu = $PauseMenu

func _ready():
	# setup game_flow
	gflow._initialize_(self)
	setup_player()
	setup_spawners()
	spawn_asteroids()
	pause_menu.set_physics_process(false)
	spawn_boss()
	
func _physics_process(delta):
	if Input.is_action_just_pressed("pause"): 
		get_tree().paused = true
		pause_menu.visible=true 
		pause_menu.set_physics_process(true)
		

# helpers
func spawn_asteroids(): 
	while asteroids.get_child_count() < asteroids.max_asteroids: 
		asteroids.spawn_algo()
	
 
func spawn_boss(): 
	boss = preload("res://Enemy/Boss.tscn").instantiate()
	boss._initialize_(player)
	boss.global_position = $Positions/boss_spawn.global_position
	boss.spawned_mob.connect(func(): Global.mobs_count+=1)
	
	add_child(boss)


func setup_player(): 
	player = preload("res://Player/player.tscn").instantiate()
	playerUI.set_health(player.max_health)
	player.health_changed.connect(playerUI.set_health)
	
	add_child(player)
	Global.cam = player.cam
	Global.player = player


func setup_spawners(): 
	for spawner in spawners.get_children(): 
		spawner.spawned_mob.connect(func(): Global.mobs_count+=1)

# signals
func _on_asteroid_check_timeout():
	spawn_asteroids()
	pass # Replace with function body.
