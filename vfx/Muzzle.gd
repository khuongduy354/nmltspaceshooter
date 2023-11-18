extends PointLight2D
@export var flash_time = .1
func flash(): 
	$Muzzle.visible = true 
	enabled = true 
	await get_tree().create_timer(flash_time).timeout
	enabled = false 
	$Muzzle.visible = false 
