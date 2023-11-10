extends CharacterBody2D
class_name Player

signal bullet_changed

@export var speed = 400 
@export var max_bullet = 100

var bullet_count = max_bullet : set = set_bullet 

func set_bullet(val): 
	if val >= 0: 
		bullet_count = val
	
	bullet_changed.emit(bullet_count)

	

func get_input(): 
	var dir = Vector2.ZERO 
	dir.y =  Input.get_axis("ui_up", "ui_down")
	dir.x = Input.get_axis("ui_left", "ui_right")
	if Input.is_action_pressed("mouse_lclick"): 
		if bullet_count > 0:
			$Gun.shoot()
	return dir

func _physics_process(delta):
	look_at(get_global_mouse_position())
	var dir = get_input()
	velocity = dir * speed
	move_and_slide()


func _on_gun_shot():
	bullet_count -= 1
