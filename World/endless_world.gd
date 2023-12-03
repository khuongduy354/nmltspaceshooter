extends World
class_name EndlessWorld

@onready var boss_spawners = $BossSpawners

func _ready():
	premade_setup()
	setup_boss_spawners()
	setup_special_spawners()
	remove_health_from_spawners()
	
func nerf_enem_health_on_spawners(): 
	for spawner in spawners.get_children(): 
		spawner.spawned_mob.connect(func(mob): mob.max_hp = 50)
func remove_health_from_spawners(): 
	for spawner in spawners.get_children(): 
		spawner.get_node("Hurtbox").set_collision_mask_value(4,false)
		spawner.get_node("GeneralHealthBar").queue_free()
		
func setup_boss_spawners(): 
	var bspawner = boss_spawners.get_child(0)
	bspawner.spawn_boss()
	bspawner.spawn_timer.start()

func setup_special_spawners(): 
	var colli = CollisionShape2D.new() 
	colli.shape = preload("res://World/EndlessWorld/planet-colli.tres")
	
	var earth = spawners.get_child(0)
	earth.get_node("Galaxy-animated").texture = preload("res://assets/Objects/planets/earth.png")
	earth.add_child(colli)
	earth.spawned_mob.connect(func(mob): mob.get_node("Enemies").texture = preload("res://assets/Objects/enemy-PhotoRoom.png-PhotoRoom (2).png"))
	
	var mars = spawners.get_child(1)
	mars.get_node("Galaxy-animated").texture = preload("res://assets/Objects/planets/mars.png")
	mars.add_child(colli)
	mars.spawned_mob.connect(func(mob): mob.get_node("Enemies").texture = preload("res://assets/Objects/enemy-PhotoRoom.png-PhotoRoom (2).png"))
	
	
