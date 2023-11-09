extends RayCast2D
@export var laser_mwidth = 30
func _physics_process(delta):
	# default to raycast length 
	var cast_point = target_position
	force_raycast_update()
	
	print(cast_point)
	# collision = shortened
	if is_colliding(): 
		cast_point = to_local(get_collision_point())
	
	$Line2D.points[1]=cast_point 
	
func turn_on(): 
	var tween =create_tween()
	tween.tween_property($Line2D,"width",laser_mwidth,0.5)

func turn_off(): 
	var tween =create_tween()
	tween.tween_property($Line2D,"width",0,1)
	pass 
