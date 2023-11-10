extends CharacterBody2D
class_name Player

signal bullet_changed
signal health_changed 

@export var speed = 400 
@export var max_bullet = 100
@export var max_health = 100

var current_health = max_health: set = set_health 
var bullet_count = max_bullet : set = set_bullet 

func set_health(val): 
	current_health = val 
	health_changed.emit(val)
	
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


func _on_hurtbox_area_entered(area):
	if area.is_in_group("enemy_bullet"): 
		current_health -= area.owner.damage
