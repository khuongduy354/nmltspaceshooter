extends Node2D

signal spawned_mob

@export var max_hp = 1000
@export var spawn_radius = 50
@export var max_mob_counts = 10
@export var base_shield = 10

@onready var mobs = $Mobs
@onready var animp = $AnimationPlayer
@onready var animp2 = $AnimationPlayer2
@onready var hbshape = $Hurtbox/CollisionShape2D

var hp = max_hp : set = set_hp 
var destroyed = false 

func _ready(): 
	hbshape.set_deferred("disabled",true)
	while mobs.get_child_count() <= 10: 
		spawn_mob()

func set_hp(val): 
	hp = val
	if hp <= 0 and !destroyed: 
		Global.spawner_destroyed.emit()
		queue_free()
		destroyed = true

func gen_spawn_pos(): 
	var x = randf_range(-spawn_radius,spawn_radius)
	var y = randf_range(-spawn_radius,spawn_radius)
	return Vector2(x,y)
	
func spawn_mob(): 
	hbshape.set_deferred("disabled",false)
	animp.play("spinning")
	var mob = preload("res://Enemy/enemy.tscn").instantiate()
	var pos = gen_spawn_pos()
	mob.position =pos
	
	mobs.add_child(mob)
	spawned_mob.emit()
	# -20 hp when its mob destroyed
	mob.destroyed.connect(_on_mob_destroyed)

func _on_spawn_timer_timeout():
	if mobs.get_child_count() > max_mob_counts: 
		return 
	spawn_mob()


func _on_hurtbox_area_entered(area):
	if area.is_in_group("player_bullet"): 
		# more mobs = less damage
		var shield = base_shield + mobs.get_child_count()*2 
		hp = hp - abs(area.owner.damage - shield)		
		animp2.play("white_flash") 
		area.owner._damage_dealt()

	# spawner take dmg attracts enem 
	Global.swarm_player.emit()
		
	


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "spinning": 
		hbshape.set_deferred("disabled",true)
		
func _on_mob_destroyed(): 
	hp -= 20
	Global.destroyed_mobs += 1
