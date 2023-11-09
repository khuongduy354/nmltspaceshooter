extends CharacterBody2D
class_name BossI

@export var move_speed = 1000 
@export var gun_counts = 12

@onready var guns = $Guns

# boss always chase player, if close enough, orbiting
enum states {LASER, CIRCLE, TRIPLE, SPAWNING, ORBITING, NONE}
var state = states.CIRCLE
var primary_gun: Gun = null

func _ready():
	setup_gun()
func setup_gun(): 
	var base_angle = 0 
	var angle_gap = 360/gun_counts
	for i in range(gun_counts): 
		var gun = preload("res://Utility/gun.tscn").instantiate()
		guns.add_child(gun)
		gun.BulletScene = preload("res://Utility/bullet.tscn")
		gun.rotation_degrees = base_angle
		base_angle+= angle_gap

func _physics_process(delta):
	match state: 
		states.SPAWNING:
			pass
		states.CIRCLE: 
			_circle(delta)
		states.TRIPLE: 
			_triple(delta) 

func _triple(delta):
	for gun in guns.get_children(): 
		if gun == primary_gun: 
			pass
	pass
func _laser(delta): 
	pass 
func _circle(delta): 
	for gun in guns.get_children(): 
		gun.shoot()


#func _move(delta): 
#	var dir = 
#	velocity = move_speed

# 1. hitbox in enemy, code in enemy
# 2. hitbox in player, code in player
