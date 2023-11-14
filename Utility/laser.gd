extends RayCast2D

@export var laser_mwidth = 10
@export var light_interval = 130

@onready var cast_ptc = $CastingParticles
@onready var colli_ptc = $CollisionParticles
@onready var beam_ptc = $BeamParticles
@onready var tail = $Tail

var is_on = false : set = set_is_on

func set_is_on(val): 
	is_on = val 
	cast_ptc.emitting = is_on
	beam_ptc.emitting = is_on
	tail.visible = is_on
	$Begin.visible = is_on
	
		
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
	var tween =create_tween()
	tween.tween_property($Line2D,"width",0,1)
	is_on = false 
	pass 
