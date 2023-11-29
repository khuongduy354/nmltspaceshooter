extends CharacterBody2D
class_name Player

signal bullet_changed
signal health_changed 

@export var max_speed = 60000
@export var accel = 2000
@export var friction = 800
@export var max_health = 1000
@export var drag = 0.5

@onready var animp = $AnimationPlayer
@onready var muzzle = $Gun/PointLight2D
@onready var cam = $Gun/Camera2D
@onready var pname = $PName/pname
@onready var tail_light = $Lighting/TailLight
@onready var gun = $Gun
@onready var sprite = $Icon

var current_health = max_health: set = set_health 
var should_look = true 
# setters
func set_health(val): 
	current_health = val 
	if current_health <= 0: 
		current_health = 0
	health_changed.emit(val)

# main functions
func _ready(): 
	$Gun/Camera2D.limit_right = Global.GAME_WIDTH
	$Gun/Camera2D.limit_bottom = Global.GAME_HEIGHT
	pname.text = Global.player_name

@export var wasd_control = true
func get_dir():
	# look 
	# space mode
	var dir = Vector2.ZERO
	if !wasd_control: 
		if Input.is_action_pressed("move"):
			dir = global_position.direction_to(get_global_mouse_position())
	else: 
		dir.x = Input.get_axis("ui_left","ui_right")
		dir.y = Input.get_axis("ui_up","ui_down")
	return dir
	

func _physics_process(delta):
	if should_look: look_at(get_global_mouse_position())
	var dir = get_dir()
	# move or idle 
	if dir != Vector2.ZERO: 
		accelerate(dir,delta)
		tail_light.enabled = true
		animp.play("fly")
	else: 
		tail_light.enabled = false
		apply_friction(delta)
		animp.play("idle")

	# shoot
	if Input.is_action_pressed("mouse_lclick"): 
		cam.shake(0.2,10)
		$Gun.shoot()
			

	$PName.global_rotation = 0
	move_and_slide()

func pick_up_item(_item): 
	match _item.item_type: 
		"HEALTH":
			current_health += 20
			_item.queue_free()	
			
# helpers
func get_input(): 
	var dir = Vector2.ZERO 
	dir.y =  Input.get_axis("ui_up", "ui_down")
	dir.x = Input.get_axis("ui_left", "ui_right")
	return dir

func accelerate(dir,delta): 
	var current_dir = global_position.direction_to($Gun.global_position) 
	velocity = velocity.move_toward(max_speed*dir*delta,accel*delta)
	
func apply_friction(delta): 
	velocity = velocity.move_toward(Vector2.ZERO, friction*delta)


# signals
func _on_gun_shot():
	muzzle.flash()

func _on_hurtbox_area_entered(area):
	if area.is_in_group("enemy_bullet"): 
		current_health -= area.owner.damage
		$AnimationPlayer2.play("white_flash") 
		area.owner._damage_dealt()
		apply_hit_particles(area.global_position)
		$HurtSound.play()
		
func apply_hit_particles(impact_pos): 
	
	#explosions
	var explosion2 = preload("res://vfx/explosion2.tscn").instantiate()
	add_child(explosion2)
	explosion2.global_position = impact_pos
	explosion2.emitting = true
	
	# cleanup
	await get_tree().create_timer(explosion2.lifetime).timeout
	explosion2.queue_free()
	

func _take_laser_damage(dmg): 
	current_health -= dmg
	$AnimationPlayer2.play("white_flash") 

