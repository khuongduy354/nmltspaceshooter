extends CharacterBody2D
class_name BossI

signal spawned_mob

@export var move_speed = 25000
@export var orbiting_speed = 15000
@export var gun_counts = 12
@export var orbiting_distance = 700

@export var max_hp = 10000

@export var laser_duration = 3
@export var straight_duration = 5
@export var circle_duration = 5
@export var triple_duration = 5 
@export var none_shoot_duration = 2
@export var spawn_duration = 3
@export var spawn_count = 1 


@onready var guns = $Guns
@onready var sdur = $shoot_duration
@onready var picker = $StatePicker as BossDecisionPicker
@onready var laser = $Laser
@onready var animp = $AnimationPlayer 
# boss always chase player, but orbiting if reach close enough
# boss spawn 3-5 ships after X interval
# while moving, choose a shooting pattern toward player

enum move_states {CHASING, ORBITING,IDLE}
enum shoot_patterns {LASER, CIRCLE, STRAIGHT, NONE, SPAWN, TRIPLE}
# straight shoot fast

var move_state = move_states.CHASING
var shoot_pattern = shoot_patterns.NONE 
var primary_gun: Gun = null
var player:Player = null 
var global_physics_pause= 0 
var should_look = true
var current_hp = max_hp

func _ready():
	picker._initialize_(self)
	state_enter(shoot_patterns.NONE)
	laser.turn_off()
	
func _physics_process(delta):
	if should_look: 
		var dir = global_position.direction_to(player.global_position)
		var dest_rot = Vector2.RIGHT.angle_to(dir)
		create_tween().tween_property(self,"rotation",dest_rot,0.5)
		
	update_debug()
	_move(delta)
		
	match shoot_pattern:
		shoot_patterns.CIRCLE: 
			_circle()
		shoot_patterns.TRIPLE: 
			_triple()
		shoot_patterns.STRAIGHT: 
			_straight()
		shoot_patterns.NONE: 
			_no_attack()
		shoot_patterns.SPAWN: 
			_spawn()
		shoot_patterns.LASER: 
			_laser()
	move_and_slide()

func change_attack_pattern(): 
	shoot_pattern = picker.pick_shoot_pattern()
	state_enter(shoot_pattern)
# move 
func _move(delta): 
	# keep distance to player
	var should_orbit = global_position.distance_to(player.global_position) <= orbiting_distance
	var dir = Vector2.ZERO
	if should_orbit:
		move_state = move_states.ORBITING
		# if in orbit zone, move in circle
		dir = global_position.direction_to(player.global_position).rotated(PI/2)
		velocity = dir * orbiting_speed * delta 
		
	else:  
		move_state = move_states.CHASING
		# if further that distance, move straight
		dir = global_position.direction_to(player.global_position) 
		velocity = dir * move_speed * delta 

# shoot patterns

# 1 time enter state
func state_enter(s): 
	sdur.stop()
	should_look = true
	if Global.cam: 
		Global.cam.shake_off()
	
	match s: 
		shoot_patterns.CIRCLE: 
			get_tree().create_timer(circle_duration).timeout.connect(change_attack_pattern)
			Global.cam.shake(circle_duration,10)
			change_ammo(1)
		shoot_patterns.TRIPLE: 
			get_tree().create_timer(triple_duration).timeout.connect(change_attack_pattern)
			Global.cam.shake(triple_duration,10)
			change_ammo(2)
		shoot_patterns.STRAIGHT: 
			get_tree().create_timer(straight_duration).timeout.connect(change_attack_pattern)
			Global.cam.shake(straight_duration,5)
			change_ammo(3  )
		shoot_patterns.NONE: 
			get_tree().create_timer(none_shoot_duration).timeout.connect(change_attack_pattern)
		shoot_patterns.SPAWN: 
			get_tree().create_timer(spawn_duration).timeout.connect(change_attack_pattern)
		shoot_patterns.LASER: 
			get_tree().create_timer(laser_duration).timeout.connect(laser.turn_off)
			laser.turned_off.connect(change_attack_pattern)
			should_look = false 
			await get_tree().create_timer(1).timeout			
			laser.turn_on()
			Global.cam.shake(laser_duration,5)

func _laser(): 
	velocity =Vector2.ZERO
	pass 
	

func _circle():
	sdur.wait_time = 1
	if !sdur.is_stopped(): 
		return

	for gun in guns.get_children(): 
		gun.shoot()
		
	if sdur.is_stopped(): 
		sdur.start()
func _spawn(): 
	if Global.mobs_count >= 40: 
		return
	sdur.wait_time = spawn_duration/spawn_count
	if !sdur.is_stopped(): 
		return
		
	var enem = preload("res://Enemy/enemy.tscn").instantiate()
	get_tree().root.add_child(enem)
	enem.global_position = global_position
	spawned_mob.emit()
	
	if sdur.is_stopped(): 
		sdur.start()
func _triple(): 
	sdur.wait_time = 0.5
	if !sdur.is_stopped(): 
		return
		
	for gun in get_3_top_gun(): 
		gun.shoot()
	
	if sdur.is_stopped(): 
		sdur.start()
func _no_attack(): 
	pass 

func _straight(): 
	sdur.wait_time = 0.2
	if !sdur.is_stopped(): 
		return

	primary_gun.shoot() 

	if sdur.is_stopped(): 
		sdur.start()
	pass

# helpers
func get_3_top_gun(): 
	var last_gun = guns.get_child(guns.get_child_count()-1)
	var sec_gun = guns.get_child(1)
	return [last_gun,primary_gun,sec_gun]
func update_debug(): 
	var move = move_states.find_key(move_state)
	var shoot = shoot_patterns.find_key(shoot_pattern)
	var display = str(move) + str("---") +str(shoot)
	$Debug.text =display
	$Debug.rotation_degrees = 0
func _initialize_(p: Player): 
	player = p
	setup_gun()

func setup_gun(): 
	# load (12) guns around boss 
	var base_angle = 0 
	var angle_gap = 360/gun_counts
	for i in range(gun_counts): 
		var gun = preload("res://Utility/gun.tscn").instantiate()
		guns.add_child(gun)
		gun.BulletScene = preload("res://Utility/boss_bullet.tscn")
		gun.rotation_degrees = base_angle
		base_angle+= angle_gap
	primary_gun = guns.get_child(0)


func _on_hurtbox_area_entered(area):
	if area.is_in_group("player_bullet"):
		current_hp -= area.owner.damage
		
		# particles 
		apply_hit_particles(area.global_position)
		
		area.owner._damage_dealt()
		if(current_hp <= 0):
			queue_free()
		

func change_ammo(i: int): 
	for gun in guns.get_children(): 
		gun.BulletScene = load("res://Utility/boss_bullet_"+str(i)+".tscn")
func apply_hit_particles(impact_pos): 
	# hit particles
	for particle in $HitParticles2.get_children(): 
		if !particle.emitting: 
			particle.emitting = true
	
	#explosions
	var explosion2 = preload("res://vfx/explosion2.tscn").instantiate()
	var explosion1 = preload("res://vfx/explosion1.tscn").instantiate()
	
	add_child(explosion1)
	add_child(explosion2)

	explosion2.global_position = impact_pos
	
	explosion1.emitting = true
	explosion2.emitting = true
	

	# white flash
	animp.play("white_flash")
	
	# cleanup
	await get_tree().create_timer(0.5).timeout
	explosion1.queue_free()
	explosion2.queue_free()
	
	
	
