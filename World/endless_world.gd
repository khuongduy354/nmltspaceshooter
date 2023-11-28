extends World
class_name EndlessWorld

func _ready():
	setup_player()
	setup_spawners()
	spawn_asteroids()
	pause_menu.set_physics_process(false)
	reset_global_params()
	pass

func _physics_process(delta): 
	super._physics_process(delta)
	pass
