extends PanelContainer

@onready var pname = $HBoxContainer/VBoxContainer/PlayerName
@onready var time_val = $HBoxContainer/VBoxContainer/HBoxContainer/TimeValue

func set_player_name(val): 
	pname.text = val
func set_time(val): 
	time_val.text = "%.1f" % val
