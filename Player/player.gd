extends CharacterBody2D
class_name Player

@export var speed = 400 

	

func get_input(): 
	var dir = Vector2.ZERO 
	dir.y =  Input.get_axis("ui_up", "ui_down")
	dir.x = Input.get_axis("ui_left", "ui_right")
	if Input.is_action_pressed("mouse_lclick"): 
		$Gun.shoot()
	return dir

func _physics_process(delta):
	look_at(get_global_mouse_position())
	var dir = get_input()
	velocity = dir * speed
	move_and_slide()
