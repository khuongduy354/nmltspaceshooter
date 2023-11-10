extends Node2D
@onready var boss = $Boss 
@onready var player = $Player as Player
@onready var playerUI = $PlayerUI
func _ready():
	boss._initialize_(player)
	playerUI.set_bullet(player.max_bullet)
	playerUI.set_health(player.max_health)
	player.bullet_changed.connect(playerUI.set_bullet)
	player.health_changed.connect(playerUI.set_health)
