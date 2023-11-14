extends Node2D
class_name Gun 

signal shot

@export var BulletScene:PackedScene
@export var fire_cooldown = 0.2
@export var spread_angle = 5.0

@onready var spos = $shoot_pos

func _ready(): 
	$fire_cooldown.wait_time = fire_cooldown
	

func shoot(): 
	if !$fire_cooldown.is_stopped(): 
		return 
	
	var bullet:Bullet = BulletScene.instantiate()
	var shoot_dir = global_position.direction_to(spos.global_position)
	
	# spread 
	var ran = randf_range(-spread_angle,spread_angle)
	shoot_dir = shoot_dir.rotated(deg_to_rad(ran))
	
	bullet.set_dir(shoot_dir) 
	add_child(bullet)
	bullet.global_position = spos.global_position


	$fire_cooldown.start()
	shot.emit()
	
