extends CanvasLayer

@onready var bulletcount = $MarginContainer/VBoxContainer/BulletCount
@onready var healthbar = $TextureProgressBar
@onready var p_info = $PlayerInfor
func _ready():
	p_info.set_player_name(Global.player_name)
func set_bullet(val:int): 
	bulletcount.text = str(val)
func set_health(val): 
	healthbar.value = val
