extends CharacterBody2D

signal destroyed

@export var move_speed = 30000
@export var patrol_radius = 300
@export var max_hp = 60
@export var min_dist = 100
@export var drag_vector = Vector2(0.15, 0.15)

@onready var pdetector = $PlayerDetector
@onready var animp = $AnimationPlayer 

enum {IDLE, PATROL, CHASE}
var state = IDLE: set = set_state
var prev_state = IDLE
var target = null
var hp = max_hp

# setters
func set_state(val):
	prev_state = state
	state = val
	
func _ready():
	Global.swarm_player.connect(func():
		target = Global.player
		state = CHASE
		)

func _physics_process(delta):
	match state: 
		IDLE: _idle()
		PATROL: _patrol(delta)
		CHASE: _chase(delta)
			
# physic process states
func _idle(): 
	velocity = Vector2.ZERO
	if $patrol_interval.is_stopped(): 
		$patrol_interval.start()
	move_and_slide()



var patrol_dir = null
var patrol_start_pos = null
func _patrol(delta): 
	# set patrol direction, and save original position
	if !patrol_dir or !patrol_start_pos: 
		patrol_dir = Vector2(randf_range(-1,1),randf_range(-1,1))
		patrol_start_pos = global_position
	
	# patrol
	velocity = patrol_dir * move_speed * delta
	move_and_slide()
	
	# if exceed patrol area => idle
	if global_position.distance_to(patrol_start_pos) >= patrol_radius: 
		patrol_dir = null
		patrol_start_pos = null
		state=IDLE
	

func _chase(delta):
	if target == null: 
		state = IDLE
		return
		
	var tpos = target.global_position
	var dir = global_position.direction_to(tpos)
	
	look_at(tpos)
	$Gun.shoot()
	
	# steering 
	var desired_velocity = dir * move_speed * delta;
	var previous_velocity = velocity;
	var change = (desired_velocity - previous_velocity) * drag_vector;
	
	velocity += change
	move_and_slide()
	
# helpers 
func is_player_in_zone(): 
	for body in pdetector.get_overlapping_bodies(): 
		if body is Player: 
			target = body
			return true
	return false
	
# signals
func _on_player_detector_body_exited(body):
	if body is Player: 
		$chase_timeout.start()



func _on_patrol_interval_timeout():
	if prev_state == IDLE: 
		state = PATROL


func _on_player_detector_body_entered(body):
	if body is Player: 
		target = body
		$patrol_interval.stop() 
		state = CHASE
		$chase_timeout.stop()

func _on_hurtbox_area_entered(area):
	if area.is_in_group("player_bullet"):
		hp -= area.owner.damage
		
		# particles 
#		var impact_vec = area.global_position.direction_to(global_position)
#		$HitParticles.rotation = Vector2.RIGHT.rotated($HitParticles.rotation).angle_to(impact_vec)
		$HitParticles.emitting = true
		$Explosion2.global_position = area.global_position
		$Explosion2.emitting = true
		animp.play("white_flash")
		
		area.owner._damage_dealt()
		
		if(hp <= 0):
			set_physics_process(false)
			await get_tree().create_timer(.5).timeout
			destroyed.emit()
			queue_free()
			$DropManager.drop_item()

func _on_chase_timeout_timeout():
	target = null
