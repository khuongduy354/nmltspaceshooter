extends Area2D
class_name Asteroid

signal exploded
enum AsteroidSize{LARGE, MEDIUM, SMALL}

@export var size = AsteroidSize.LARGE
@export var min_speed = 50 
@export var max_speed = 100

@onready var sprite =$Sprite2D 
@onready var colli_shape = $CollisionShape2D 


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
			sprite.texture = preload("res://assets/meteorGrey_big4.png")
			colli_shape.shape = preload("res://World/Asteriod/LargeAsteroidCollision.tres")
		AsteroidSize.MEDIUM:
			sprite.texture = preload("res://assets/meteorGrey_med2.png") 
			speed*=1.2
			colli_shape.shape = preload("res://World/Asteriod/MedAsteroidCollision.tres")
		AsteroidSize.SMALL: 
			sprite.texture = preload("res://assets/asteroid_small.png") 
			speed*=1.5
			colli_shape.shape = preload("res://World/Asteriod/SmallAsteroidCollision.tres")
			


func _on_area_entered(area):
#	area.owner._damage_dealt()
	exploded.emit(global_position,size)
	queue_free()
