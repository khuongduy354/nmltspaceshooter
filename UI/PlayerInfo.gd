extends Panel

@onready var pname = $PlayerName

func set_player_name(val): 
	pname.text = val
