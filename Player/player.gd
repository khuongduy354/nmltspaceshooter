extends CharacterBody2D
class_name Player

signal bullet_changed
signal health_changed 

@export var max_speed = 60000
@export var accel = 2000
@export var friction = 800
@export var max_bullet = 100
@export var max_health = 100
@export var drag = 0.5

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
	var current_dir = global_position.direction_to($Gun.global_position) 
	
	
	velocity = velocity.move_toward(max_speed*dir*delta,accel*delta)
	
	
func apply_friction(delta): 
	velocity = velocity.move_toward(Vector2.ZERO, friction*delta)

func format_rot(rot: float, is_neg = false): 
	if is_neg:
		# 120 -> -240 for example 
		if rot > 0: 
			rot = rot - 360.0
	else:
		# -240 -> 120 for example
		if rot < 0: 
			rot = rot + 360.0
			
	return rot
	
	
func _physics_process(delta):
	var dir = global_position.direction_to(get_global_mouse_position())
	look_at(get_global_mouse_position())
	# move 
	if Input.is_action_pressed("move"): 
		accelerate(dir,delta)
		$TailLight.enabled = true
		animp.play("fly")
	else: 
		$TailLight.enabled = false
		apply_friction(delta)
		animp.play("idle")
		
	# shoot
	if Input.is_action_pressed("mouse_lclick"): 
		cam.shake(0.2,10)
		$Gun.shoot()
			

	$PName.global_rotation = 0
	move_and_slide()


func _on_gun_shot():
	bullet_count -= 1
	muzzle.flash()


func _on_hurtbox_area_entered(area):
	if area.is_in_group("enemy_bullet"): 
		current_health -= area.owner.damage
