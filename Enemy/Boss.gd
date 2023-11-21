extends CharacterBody2D
class_name BossI

signal spawned_mob

@export var move_speed = 25000
@export var orbiting_speed = 15000
@export var gun_counts = 12
@export var orbiting_distance = 1500
@export var max_hp = 10000

@onready var guns = $Guns
@onready var sdur = $shoot_duration
@onready var picker = $BossDecisionPicker as BossDecisionPicker
@onready var fsm = $BossStateManager as BossStateManager
@onready var laser = $Laser
@onready var animp = $AnimationPlayer 


var primary_gun: Gun = null
var player:Player = null 
var should_look = true
var current_hp = max_hp

func _initialize_(p: Player): 
	player = p
	
func _ready():
	fsm._initialize_(self)
	setup_gun()
	picker._initialize_(self)
	laser.turn_off()
	
func _physics_process(delta):
#	apply_rotation()
	if should_look: 
		look_at(player.global_position)
	update_debug()
	_move(delta)


func _move(delta): 
	var should_orbit = global_position.distance_to(player.global_position) <= orbiting_distance
	var dir = Vector2.ZERO
	
	# orbiting when close enough
	if should_orbit:
		dir = global_position.direction_to(player.global_position).rotated(PI/2)
		velocity = dir * orbiting_speed * delta 
	else:  
		dir = global_position.direction_to(player.global_position) 
		velocity = dir * move_speed * delta 



# helpers
func apply_rotation():
	if should_look: 
		var dir = global_position.direction_to(player.global_position)
		var dest_rot = Vector2.RIGHT.angle_to(dir)
		create_tween().tween_property(self,"rotation",dest_rot,0.5)

func get_3_top_gun(): 
	var last_gun = guns.get_child(guns.get_child_count()-1)
	var sec_gun = guns.get_child(1)
	return [last_gun,primary_gun,sec_gun]
	
func update_debug(): 
	var shoot = fsm.shoot_patterns.find_key(fsm.shoot_pattern)
	var display = str(shoot)
	$Debug.text =display
	$Debug.rotation_degrees = 0
	

func setup_gun(): 
	# load 12 guns around boss 
	var base_angle = 0 
	var angle_gap = 360/gun_counts
	
	for i in range(gun_counts): 
		var gun = preload("res://Utility/gun.tscn").instantiate()
		guns.add_child(gun)
		gun.BulletScene = preload("res://Utility/boss_bullet.tscn")
		gun.rotation_degrees = base_angle
		base_angle+= angle_gap
		
	primary_gun = guns.get_child(0)

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
	

# signals 
func _on_hurtbox_area_entered(area):
	if area.is_in_group("player_bullet"):
		current_hp -= area.owner.damage
		
		# particles 
		apply_hit_particles(area.global_position)
		
		area.owner._damage_dealt()
		if(current_hp <= 0):
			queue_free()
#		Global.frame_freeze(0.8,.5)
	
