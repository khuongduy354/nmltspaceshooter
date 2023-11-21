extends Area2D
class_name Asteroid

signal exploded
enum AsteroidSize{LARGE, MEDIUM, SMALL}

@export var size = AsteroidSize.LARGE
@export var min_speed = 50 
@export var max_speed = 100

@onready var sprite =$Sprite2D 
@onready var colli_shape = $CollisionShape2D 
@onready var realcolli_shape = $RigidBody2D/CollisionShape2D

@onready var large =preload("res://World/Asteriod/LargeAsteroidCollision.tres")
@onready var med = preload("res://World/Asteriod/MedAsteroidCollision.tres")
@onready var small = preload("res://World/Asteriod/SmallAsteroidCollision.tres")

var movement_vector := Vector2(0, -1)
var speed = min_speed

func _ready():
	colli_shape.set_deferred("disabled",true)
	setup_size()
	
	rotation = randf_range(0, 2*PI)
	
	await get_tree().create_timer(1).timeout
	colli_shape.set_deferred("disabled",false)
	

	
func _physics_process(delta):
	global_position += movement_vector.rotated(rotation) * speed * delta
	
	# check out screen 
	if Global.check_out_screen(global_position): 
		queue_free()

# helpers 
func setup_size(): 
	speed = randf_range(min_speed, max_speed)
	match size: 
		AsteroidSize.LARGE:
			sprite.texture = preload("res://assets/Objects/meteorGrey_big4.png")
			colli_shape.shape = large
			realcolli_shape.shape = large
		AsteroidSize.MEDIUM:
			sprite.texture = preload("res://assets/Objects/meteorGrey_med2.png") 
			speed*=1.2
			colli_shape.shape = med
#			realcolli_shape.shape = med
			
		AsteroidSize.SMALL: 
			sprite.texture = preload("res://assets/Objects/asteroid_small.png") 
			speed*=1.5
			colli_shape.shape = small
#			realcolli_shape.shape = small
			


func _on_area_entered(area):
#	area.owner._damage_dealt()
	exploded.emit(global_position,size)
	queue_free()
