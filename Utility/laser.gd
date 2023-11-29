extends RayCast2D

signal turned_off

@export var laser_mwidth = 10
@export var light_interval = 130
@export var dmg_per_tick = 2

@onready var cast_ptc = $CastingParticles
@onready var colli_ptc = $CollisionParticles
@onready var beam_ptc = $BeamParticles
@onready var tail = $Tail
@onready var lights = $Lights
var is_on = false : set = set_is_on

func set_is_on(val): 
	is_on = val 
	cast_ptc.emitting = is_on
	beam_ptc.emitting = is_on
	tail.visible = is_on 
	$Begin.visible = is_on 
	beam_ptc.emitting = is_on
	if is_on: 
		$StandardAudio.play()	

func apply_light(): 
#	$WorldEnvironment.glow.enabled = isn
	var pos = $Line2D.points[1]
	if is_on: 
		var mid = (pos + Vector2.ZERO)/2
		$StandardLight.position = mid 
		$StandardLight.enabled = true 

	elif $Line2D.width == 0: 
		$StandardLight.enabled = false
func _physics_process(delta):
	# default to raycast length 
	var cast_point = target_position
	force_raycast_update()
	
	colli_ptc.emitting = is_colliding() and is_on
	# collision = shortened
	if is_colliding(): 
		cast_point = to_local(get_collision_point())
	
		# set colli particles
		colli_ptc.position = cast_point
		colli_ptc.global_rotation = get_collision_normal().angle() - PI/2
		
		# deals dmg
		if is_on: 
			var player_hurtbox = get_collider()
			player_hurtbox.owner._take_laser_damage(dmg_per_tick)

	tail.position = cast_point
	$Line2D.points[1]=cast_point 
	
	# set beam particles 
	beam_ptc.position = cast_point * 0.5 
	beam_ptc.process_material.emission_box_extents.x=cast_point.length()*0.5
	
func turn_on(): 
	var tween =create_tween()
	tween.tween_property($Line2D,"width",laser_mwidth,0.5)
	is_on = true 
func turn_off(): 
	is_on = false 
	var tween =create_tween()
	tween.tween_property($Line2D,"width",0,1)
	tween.tween_callback(func(): turned_off.emit())
	pass 
