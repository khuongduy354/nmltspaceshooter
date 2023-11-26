extends Node2D

func _ready():
	for mob in $Spawner.mobs.get_children(): 
		mob.queue_free()
	$Spawner.spawned_mob.connect(_on_mob_spawn)
func _on_mob_spawn(): 
	for mob in $Spawner.mobs.get_children(): 
		mob.colli_shape.set_deferred("disabled", true)
