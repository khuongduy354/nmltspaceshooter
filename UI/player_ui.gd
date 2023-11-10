extends CanvasLayer

@onready var bulletcount = $MarginContainer/VBoxContainer/BulletCount
@onready var healthbar = $TextureProgressBar
func set_bullet(val:int): 
	bulletcount.text = str(val)
func set_health(val): 
	healthbar.value = val
