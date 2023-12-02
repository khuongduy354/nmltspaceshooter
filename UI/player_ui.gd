extends CanvasLayer

@onready var healthbar = $TextureProgressBar
@onready var p_info = $HBoxContainer/PlayerInfor
func _ready():
	p_info.set_player_name(Global.player_name)

func set_time(val): 
	p_info.set_time(val)
	Global.survival_time = floor(val) 
	
func set_max_health(val): 
	healthbar.max_value = val
	
func set_health(val): 
	healthbar.value = val
