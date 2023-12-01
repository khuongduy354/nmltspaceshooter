extends World
class_name EndlessWorld

@onready var boss_spawners = $BossSpawners

func _ready():
	premade_setup()
	setup_boss_spawners()
	
func setup_boss_spawners(): 
	var bspawner = boss_spawners.get_child(0)
	bspawner.spawn_boss()
	bspawner.spawn_timer.start()
