extends PointLight2D
@export var flash_time = .1
func flash(): 
	$Muzzle.visible = true 
	enabled = true 
	await get_tree().create_timer(flash_time).timeout
	enabled = false 
	$Muzzle.visible = false 

	apply_particles() 
	

func apply_particles():
	var dup = $HitParticles.duplicate()
	add_child(dup)
	dup.emitting = true
	await get_tree().create_timer(1).timeout
	dup.queue_free()
