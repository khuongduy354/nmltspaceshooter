extends Node
class_name BossStateManager

@export var laser_duration = 3
@export var straight_duration = 5
@export var circle_duration = 5
@export var triple_duration = 5 
@export var none_shoot_duration = 2
@export var spawn_duration = 3
@export var spawn_count = 2 

enum shoot_patterns {LASER, CIRCLE, STRAIGHT, NONE, SPAWN, TRIPLE}

var b: BossI = null
var sdur: Timer = null
var laser = null 
var shoot_pattern = shoot_patterns.NONE : set = set_shoot_state

# setters
func set_shoot_state(val):
	state_exit(shoot_pattern)
	shoot_pattern = val
	state_enter(shoot_pattern)

func _initialize_(_b:BossI): 
	b = _b
	sdur = b.sdur
	laser = b.laser
	shoot_pattern = shoot_patterns.NONE

func _physics_process(delta):
	match shoot_pattern:
		shoot_patterns.CIRCLE: 
			_circle()
		shoot_patterns.TRIPLE: 
			_triple()
		shoot_patterns.STRAIGHT: 
			_straight()
		shoot_patterns.NONE: 
			_no_attack()
		shoot_patterns.SPAWN: 
			_spawn()
		shoot_patterns.LASER: 
			_laser()
	b.move_and_slide()

# enter state
func state_enter(s): 
	match s: 
		shoot_patterns.CIRCLE: 
			get_tree().create_timer(circle_duration).timeout.connect(change_attack_pattern)
			Global.cam.shake(circle_duration,10)
			change_ammo(1)
		shoot_patterns.TRIPLE: 
			get_tree().create_timer(triple_duration).timeout.connect(change_attack_pattern)
			Global.cam.shake(triple_duration,10)
			change_ammo(2)
		shoot_patterns.STRAIGHT: 
			get_tree().create_timer(straight_duration).timeout.connect(change_attack_pattern)
			Global.cam.shake(straight_duration,5)
			change_ammo(3 )
		shoot_patterns.NONE: 
			get_tree().create_timer(none_shoot_duration).timeout.connect(change_attack_pattern)
		shoot_patterns.SPAWN: 
			get_tree().create_timer(spawn_duration).timeout.connect(change_attack_pattern)
		shoot_patterns.LASER: 
			get_tree().create_timer(laser_duration).timeout.connect(laser.turn_off)
			laser.turned_off.connect(change_attack_pattern)
			b.should_look = false 
			await get_tree().create_timer(1).timeout			
			laser.turn_on()
			Global.cam.shake(laser_duration,5)
# state exit 
func state_exit(s): 
	sdur.stop()
	if Global.cam: 
		Global.cam.shake_off()
	
	match s: 
		shoot_patterns.CIRCLE: 
			pass
		shoot_patterns.TRIPLE: 
			pass
		shoot_patterns.STRAIGHT: 
			b.primary_gun.fire_cooldown += 0.2
		shoot_patterns.NONE: 
			pass 
		shoot_patterns.SPAWN: 
			pass
		shoot_patterns.LASER: 
			b.should_look = true
			pass

# physic process states
func _laser(): 
	b.velocity =Vector2.ZERO

func _circle():
	sdur.wait_time = 1
	if !sdur.is_stopped(): 
		return

	# shooot all directions at once
	for gun in b.guns.get_children(): 
		gun.shoot()
		
	if sdur.is_stopped(): 
		sdur.start()
		
func _spawn(): 
	# limit mobs count
	if Global.mobs_count >= 40: 
		return

	sdur.wait_time = spawn_duration/spawn_count
	if !sdur.is_stopped(): 
		return
	
	# spawn
	var enem = preload("res://Enemy/enemy.tscn").instantiate()
	get_tree().root.add_child(enem)
	enem.global_position = b.global_position
	b.spawned_mob.emit()

	if sdur.is_stopped(): 
		sdur.start()

func _triple(): 
	sdur.wait_time = 0.5
	if !sdur.is_stopped(): 
		return
	
	# shoot 3 guns (primary + its neighbors)	
	for gun in b.get_3_top_gun(): 
		gun.shoot()
	
	if sdur.is_stopped(): 
		sdur.start()

func _no_attack(): 
	pass 

func _straight(): 
	sdur.wait_time = 0.2
	if !sdur.is_stopped(): 
		return
	
	# shoot primary only, and faster
	b.primary_gun.shoot() 
	b.primary_gun.fire_cooldown -= 0.2

	if sdur.is_stopped(): 
		sdur.start()


# helpers 
func change_ammo(i): 
	b.change_ammo(i)

func change_attack_pattern(): 
	shoot_pattern = b.picker.pick_shoot_pattern()
