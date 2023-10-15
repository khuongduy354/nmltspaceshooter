extends Node2D
class_name Gun 
@export var BulletScene:PackedScene
@export var fire_cooldown = 0.2
@onready var spos = $shoot_pos

func _ready(): 
	$fire_cooldown.wait_time = fire_cooldown
	

func shoot(): 
	if !$fire_cooldown.is_stopped(): 
		return 
	var bullet:Bullet = BulletScene.instantiate()
	var shoot_dir = global_position.direction_to(spos.global_position)
	bullet.set_dir(shoot_dir) 
	add_child(bullet)
	bullet.global_position = spos.global_position
	$fire_cooldown.start()
