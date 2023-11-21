extends Node2D

@onready var boss = $Boss 
@onready var player = $Player as Player
@onready var playerUI = $PlayerUI
@onready var asteroids = $Asteroids 
@onready var pause_menu = $PauseMenu
@onready var spawners = $Spawners

func _ready():
	Global.cam = player.cam
	boss._initialize_(player)
	boss.spawned_mob.connect(func(): Global.mobs_count+=1)
	
	for spawner in spawners.get_children(): 
		spawner.spawned_mob.connect(func(): Global.mobs_count+=1)
	
	playerUI.set_bullet(player.max_bullet)
	playerUI.set_health(player.max_health)
	player.bullet_changed.connect(playerUI.set_bullet)
	player.health_changed.connect(playerUI.set_health)
	
	spawn_asteroids()
	
func _physics_process(delta):
	if Input.is_action_just_pressed("pause"): 
		pause_menu.visible=true 
		get_tree().paused = true

# asteroids 
func spawn_asteroids(): 
	while asteroids.get_child_count() < asteroids.max_asteroids: 
		asteroids.spawn_algo()
	


func _on_asteroid_check_timeout():
	spawn_asteroids()
	pass # Replace with function body.
