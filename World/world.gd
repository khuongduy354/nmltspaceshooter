extends Node2D
@onready var boss = $Boss 
@onready var player = $Player as Player
@onready var playerUI = $PlayerUI
@onready var asteroids = $Asteroids 
func _ready():
	boss._initialize_(player)
	
	playerUI.set_bullet(player.max_bullet)
	playerUI.set_health(player.max_health)
	player.bullet_changed.connect(playerUI.set_bullet)
	player.health_changed.connect(playerUI.set_health)
	
	spawn_asteroids()
	


# asteroids 
func spawn_asteroids(): 
	while asteroids.get_child_count() < asteroids.max_asteroids: 
		asteroids.spawn_algo()
	


func _on_asteroid_check_timeout():
#	spawn_asteroids()
	pass # Replace with function body.
