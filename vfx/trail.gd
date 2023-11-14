extends Line2D

@export var plen = 50 

@export var is_on = true

var p = null
var point = Vector2() 

func _ready():
	p = get_parent()
func turn_on(): 
	is_on = true 
	pass 
func turn_off(): 
	is_on = false
func _process(delta):
	if !is_on: 
		return 
	global_position = Vector2.ZERO
	global_rotation = 0 
	
	point = p.global_position 
	add_point(point)
	
	while get_point_count() > plen: 
		remove_point(0)
