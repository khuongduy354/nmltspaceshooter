extends CharacterBody2D
class_name Bullet

signal dealt_damage

@export var BULLET_SPEED = 1000
@export var damage = 50
@export var max_distance = 6000

var original_pos = null
var veloc = Vector2.ZERO

func _ready():
	var audio = get_node("StandardAudio")
	if audio: 
		audio.play()
#	$Hitbox.connect("body_entered",Callable(self,"_on_hitbox_body_entered"))
	original_pos = global_position
	$VisibleOnScreenNotifier2D.connect("screen_exited",queue_free)
	set_as_top_level(true)

	
func _physics_process(delta):
	if global_position.distance_to(original_pos) > max_distance: 
		queue_free()
	move_and_collide(veloc*delta)
	
func _damage_dealt(): 
	emit_signal("dealt_damage")
	self.queue_free()
	
	
func set_dir(dir:Vector2): 
	dir = dir.normalized()
	veloc = dir * BULLET_SPEED
	look_at(self.global_position+dir)  


