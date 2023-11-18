extends CharacterBody2D
class_name Player

signal bullet_changed
signal health_changed 

@export var max_speed = 800
@export var accel = 1400
@export var friction = 800
@export var max_bullet = 100
@export var max_health = 100

@onready var animp = $AnimationPlayer
@onready var muzzle = $Gun/PointLight2D
@onready var cam = $Gun/Camera2D
@onready var pname = $PName/pname

var current_health = max_health: set = set_health 
var bullet_count = max_bullet : set = set_bullet 

func pick_up_item(_item): 
	match _item.item_type: 
		"HEALTH":
			current_health += 20
			_item.queue_free()
			
func set_health(val): 
	current_health = val 
	if current_health <= 0: 
		current_health = 0
	health_changed.emit(val)
	
func set_bullet(val): 
	if val >= 0: 
		bullet_count = val
	
	bullet_changed.emit(bullet_count)

	

func get_input(): 
	var dir = Vector2.ZERO 
	dir.y =  Input.get_axis("ui_up", "ui_down")
	dir.x = Input.get_axis("ui_left", "ui_right")

	return dir
func _ready(): 
	$Gun/Camera2D.limit_right = Global.GAME_WIDTH
	$Gun/Camera2D.limit_bottom = Global.GAME_HEIGHT
	pname.text = Global.player_name
	
func accelerate(dir,delta): 
	velocity = velocity.move_toward(max_speed*dir,accel*delta)
func apply_friction(delta): 
	velocity = velocity.move_toward(Vector2.ZERO, friction*delta)
func _process(delta):
	look_at(get_global_mouse_position())
	print(global_position)
func _physics_process(delta):
	var dir = global_position.direction_to(get_global_mouse_position())
	
	# move 
	velocity = velocity.rotated(velocity.angle_to(dir))
	apply_friction(delta)
	if Input.is_action_pressed("move"): 
		accelerate(dir,delta)
		animp.play("fly")
	else: 
		apply_friction(delta)
		animp.play("idle")
		
	# shoot
	if Input.is_action_pressed("mouse_lclick"): 
		if bullet_count > 0:
			cam.shake(0.2,5)
			muzzle.flash()
			$Gun.shoot()
			

	$PName.global_rotation = 0
	move_and_slide()


func _on_gun_shot():
	bullet_count -= 1


func _on_hurtbox_area_entered(area):
	if area.is_in_group("enemy_bullet"): 
		current_health -= area.owner.damage
