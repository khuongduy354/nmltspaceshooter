extends PointLight2D
@export var flash_time = .2
func flash(): 
	$Muzzle.visible = true 
	await get_tree().create_timer(flash_time).timeout
	$Muzzle.visible = false 

	apply_particles() 
	

func apply_particles():
	var dup = $HitParticles.duplicate()
	add_child(dup)
	dup.emitting = true
	await get_tree().create_timer(1).timeout
	dup.queue_free()
